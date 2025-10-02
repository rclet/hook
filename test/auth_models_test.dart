import 'package:flutter_test/flutter_test.dart';
import 'package:pipit/models/auth_models.dart';

void main() {
  group('AuthUser Model Tests', () {
    test('AuthUser.fromJson should parse JSON with role correctly', () {
      final json = {
        'id': 1,
        'name': 'Admin User',
        'email': 'sayma@gopipit.com',
        'email_verified_at': '2024-01-01T00:00:00.000Z',
        'phone': '+1234567890',
        'avatar': 'https://example.com/avatar.jpg',
        'role': 'admin',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      final user = AuthUser.fromJson(json);

      expect(user.id, 1);
      expect(user.name, 'Admin User');
      expect(user.email, 'sayma@gopipit.com');
      expect(user.role, 'admin');
      expect(user.isAdmin, true);
    });

    test('AuthUser.fromJson should handle missing role field', () {
      final json = {
        'id': 2,
        'name': 'Regular User',
        'email': 'user@example.com',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
      };

      final user = AuthUser.fromJson(json);

      expect(user.id, 2);
      expect(user.name, 'Regular User');
      expect(user.role, null);
      expect(user.isAdmin, false);
    });

    test('AuthUser.isAdmin should return true for admin role', () {
      const user = AuthUser(
        id: 1,
        name: 'Admin User',
        email: 'admin@example.com',
        role: 'admin',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-01T00:00:00.000Z',
      );

      expect(user.isAdmin, true);
    });

    test('AuthUser.isAdmin should return true for ADMIN role (case insensitive)', () {
      const user = AuthUser(
        id: 1,
        name: 'Admin User',
        email: 'admin@example.com',
        role: 'ADMIN',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-01T00:00:00.000Z',
      );

      expect(user.isAdmin, true);
    });

    test('AuthUser.isAdmin should return false for non-admin role', () {
      const user = AuthUser(
        id: 2,
        name: 'Regular User',
        email: 'user@example.com',
        role: 'user',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-01T00:00:00.000Z',
      );

      expect(user.isAdmin, false);
    });

    test('AuthUser.isAdmin should return false for null role', () {
      const user = AuthUser(
        id: 3,
        name: 'User Without Role',
        email: 'norole@example.com',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-01T00:00:00.000Z',
      );

      expect(user.isAdmin, false);
    });

    test('AuthUser.toJson should serialize role correctly', () {
      const user = AuthUser(
        id: 1,
        name: 'Admin User',
        email: 'admin@example.com',
        role: 'admin',
        createdAt: '2024-01-01T00:00:00.000Z',
        updatedAt: '2024-01-01T00:00:00.000Z',
      );

      final json = user.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Admin User');
      expect(json['email'], 'admin@example.com');
      expect(json['role'], 'admin');
      expect(json['created_at'], '2024-01-01T00:00:00.000Z');
      expect(json['updated_at'], '2024-01-01T00:00:00.000Z');
    });
  });

  group('AuthResponse Model Tests', () {
    test('AuthResponse.fromJson should parse response with admin user', () {
      final json = {
        'success': true,
        'message': 'Login successful',
        'user': {
          'id': 1,
          'name': 'Admin User',
          'email': 'sayma@gopipit.com',
          'role': 'admin',
          'created_at': '2024-01-01T00:00:00.000Z',
          'updated_at': '2024-01-01T00:00:00.000Z',
        },
        'token': 'sample-jwt-token',
        'token_type': 'Bearer',
        'expires_in': 3600,
      };

      final response = AuthResponse.fromJson(json);

      expect(response.success, true);
      expect(response.message, 'Login successful');
      expect(response.user?.role, 'admin');
      expect(response.user?.isAdmin, true);
      expect(response.token, 'sample-jwt-token');
      expect(response.tokenType, 'Bearer');
      expect(response.expiresIn, 3600);
    });
  });
}
