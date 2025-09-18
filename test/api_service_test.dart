import 'package:flutter_test/flutter_test.dart';
import 'package:pipit/services/api_service.dart';
import 'package:pipit/models/api_response.dart';

void main() {
  group('ApiService Tests', () {
    late ApiService apiService;

    setUp(() {
      apiService = ApiService();
    });

    tearDown(() {
      apiService.dispose();
    });

    test('ApiService should be created with correct base URL', () {
      expect(ApiService.baseUrl, 'https://gig.com.bd/gig-main/backend/public/api');
    });

    test('ApiResponse.success should create successful response', () {
      const testData = 'test data';
      const testMessage = 'success message';
      
      final response = ApiResponse.success(testData, testMessage);
      
      expect(response.isSuccess, true);
      expect(response.hasError, false);
      expect(response.data, testData);
      expect(response.message, testMessage);
      expect(response.error, null);
    });

    test('ApiResponse.error should create error response', () {
      const errorMessage = 'test error';
      
      final response = ApiResponse<String>.error(errorMessage);
      
      expect(response.isSuccess, false);
      expect(response.hasError, true);
      expect(response.data, null);
      expect(response.message, null);
      expect(response.error, errorMessage);
    });

    // Note: Network tests would require mocking HTTP client
    // This is a basic test structure for the API service
  });
}