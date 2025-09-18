import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';

class ApiService {
  static const String baseUrl = 'https://gig.com.bd/gig-main/backend/public/api';
  
  final http.Client _client = http.Client();

  /// Headers for API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'Pipit-Nupuit/1.0.0',
  };

  /// Generic GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final finalUri = queryParams != null 
          ? uri.replace(queryParameters: queryParams)
          : uri;

      final response = await _client.get(finalUri, headers: _headers);
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Generic POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await _client.post(
        uri,
        headers: _headers,
        body: body != null ? json.encode(body) : null,
      );
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Handle HTTP response
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    try {
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (fromJson != null && jsonData['data'] != null) {
          final data = fromJson(jsonData['data'] as Map<String, dynamic>);
          return ApiResponse.success(data, jsonData['message'] as String?);
        }
        return ApiResponse.success(null, jsonData['message'] as String?);
      } else {
        return ApiResponse.error(
          jsonData['message'] as String? ?? 'Unknown error occurred'
        );
      }
    } catch (e) {
      return ApiResponse.error('Failed to parse response: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _client.close();
  }
}