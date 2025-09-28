import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/environment.dart';
import '../models/api_response.dart';

class ApiService {
  late Dio _dio;
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  
  // Storage keys
  static const String _tokenKey = 'auth_token';
  static const String _tokenTypeKey = 'token_type';
  static const String _userKey = 'user_data';

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'Pipit-Hook/1.0.0',
      },
    ));

    // Add request interceptor for authentication
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getAuthToken();
        if (token != null) {
          final tokenType = await _storage.read(key: _tokenTypeKey) ?? 'Bearer';
          options.headers['Authorization'] = '$tokenType $token';
        }
        
        if (AppConfig.isDebug) {
          print('🚀 ${options.method} ${options.uri}');
          if (options.data != null) {
            print('📤 Request data: ${options.data}');
          }
        }
        
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (AppConfig.isDebug) {
          print('✅ ${response.statusCode} ${response.requestOptions.uri}');
          print('📥 Response data: ${response.data}');
        }
        handler.next(response);
      },
      onError: (error, handler) {
        if (AppConfig.isDebug) {
          print('❌ ${error.response?.statusCode} ${error.requestOptions.uri}');
          print('🔥 Error: ${error.message}');
          if (error.response?.data != null) {
            print('📥 Error data: ${error.response?.data}');
          }
        }
        
        // Handle 401 unauthorized - clear token and redirect to login
        if (error.response?.statusCode == 401) {
          clearAuthToken();
        }
        
        handler.next(error);
      },
    ));
  }

  // Auth token management
  Future<String?> getAuthToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> setAuthToken(String token, {String tokenType = 'Bearer'}) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _tokenTypeKey, value: tokenType);
  }

  Future<void> clearAuthToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _tokenTypeKey);
    await _storage.delete(key: _userKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // Generic GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
      );
      
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  // Generic POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
      );
      
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  // Generic PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
      );
      
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  // Generic DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(endpoint);
      
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  // Handle HTTP response
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    try {
      if (response.statusCode != null && 
          response.statusCode! >= 200 && 
          response.statusCode! < 300) {
        
        // Handle different response structures
        final responseData = response.data;
        
        if (responseData is Map<String, dynamic>) {
          final success = responseData['success'] ?? true;
          final message = responseData['message'] as String?;
          
          if (success) {
            if (fromJson != null && responseData['data'] != null) {
              final data = fromJson(responseData['data'] as Map<String, dynamic>);
              return ApiResponse.success(data, message);
            } else if (fromJson != null && responseData is Map<String, dynamic>) {
              // Handle cases where the entire response is the data
              final data = fromJson(responseData);
              return ApiResponse.success(data, message);
            }
            return ApiResponse.success(null, message);
          } else {
            return ApiResponse.error(
              message ?? 'Request failed'
            );
          }
        } else if (responseData is List && fromJson != null) {
          // Handle list responses
          final data = fromJson({'items': responseData});
          return ApiResponse.success(data, 'Success');
        }
        
        return ApiResponse.success(null, 'Success');
      } else {
        return ApiResponse.error(
          'HTTP ${response.statusCode}: ${response.statusMessage}'
        );
      }
    } catch (e) {
      return ApiResponse.error('Failed to parse response: $e');
    }
  }

  // Handle Dio errors
  ApiResponse<T> _handleDioError<T>(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiResponse.error('Connection timeout. Please check your internet connection.');
      case DioExceptionType.sendTimeout:
        return ApiResponse.error('Request timeout. Please try again.');
      case DioExceptionType.receiveTimeout:
        return ApiResponse.error('Response timeout. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        
        if (responseData is Map<String, dynamic>) {
          final message = responseData['message'] as String?;
          if (message != null) {
            return ApiResponse.error(message);
          }
        }
        
        switch (statusCode) {
          case 401:
            return ApiResponse.error('Unauthorized. Please log in again.');
          case 403:
            return ApiResponse.error('Access denied.');
          case 404:
            return ApiResponse.error('Resource not found.');
          case 422:
            // Handle validation errors
            if (responseData is Map<String, dynamic> && 
                responseData['errors'] != null) {
              final errors = responseData['errors'] as Map<String, dynamic>;
              final firstError = errors.values.first;
              if (firstError is List && firstError.isNotEmpty) {
                return ApiResponse.error(firstError.first.toString());
              }
            }
            return ApiResponse.error('Validation failed.');
          case 500:
            return ApiResponse.error('Server error. Please try again later.');
          default:
            return ApiResponse.error('HTTP $statusCode: ${error.response?.statusMessage}');
        }
      case DioExceptionType.cancel:
        return ApiResponse.error('Request cancelled.');
      case DioExceptionType.unknown:
        return ApiResponse.error('Network error. Please check your internet connection.');
      default:
        return ApiResponse.error('Unexpected error occurred.');
    }
  }

  // Multipart file upload
  Future<ApiResponse<T>> uploadFile<T>(
    String endpoint,
    String filePath,
    String fieldName, {
    Map<String, dynamic>? data,
    T Function(Map<String, dynamic>)? fromJson,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        ...?data,
        fieldName: await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleDioError<T>(e);
    } catch (e) {
      return ApiResponse.error('File upload failed: $e');
    }
  }

  // Close Dio instance
  void dispose() {
    _dio.close();
  }
}