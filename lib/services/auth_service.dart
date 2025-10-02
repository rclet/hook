import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/api_response.dart';
import '../models/auth_models.dart';
import 'enhanced_api_service.dart';

class AuthService {
  final ApiService _apiService;
  final firebase.FirebaseAuth _firebaseAuth = firebase.FirebaseAuth.instance;
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  
  static const String _userKey = 'user_data';

  AuthService(this._apiService);

  // Get current Firebase user
  firebase.User? get currentFirebaseUser => _firebaseAuth.currentUser;

  // Get current authenticated user from storage
  Future<AuthUser?> getCurrentUser() async {
    try {
      final userData = await _storage.read(key: _userKey);
      if (userData != null) {
        final userJson = Map<String, dynamic>.from(
          await _storage.read(key: _userKey).then((value) => 
            value != null ? Uri.splitQueryString(value) : <String, dynamic>{}
          )
        );
        return AuthUser.fromJson(userJson);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Store user data
  Future<void> _storeUserData(AuthUser user) async {
    final userJson = user.toJson();
    final userString = userJson.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
    await _storage.write(key: _userKey, value: userString);
  }

  // Clear user data
  Future<void> _clearUserData() async {
    await _storage.delete(key: _userKey);
  }

  // Register with email and password
  Future<ApiResponse<AuthUser>> register(RegisterRequest request) async {
    try {
      // First, create Firebase user
      final firebaseCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: request.email,
        password: request.password,
      );

      if (firebaseCredential.user == null) {
        return ApiResponse.error('Failed to create Firebase account');
      }

      // Update Firebase profile
      await firebaseCredential.user!.updateDisplayName(request.name);

      // Get Firebase ID token
      final idToken = await firebaseCredential.user!.getIdToken();

      // Register with backend API using Firebase ID token
      final response = await _apiService.post<AuthResponse>(
        '/auth/register',
        data: {
          ...request.toJson(),
          'firebase_uid': firebaseCredential.user!.uid,
          'firebase_token': idToken,
        },
        fromJson: (json) => AuthResponse.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        final authResponse = response.data!;
        
        if (authResponse.success && 
            authResponse.user != null && 
            authResponse.token != null) {
          
          // Store auth token and user data
          await _apiService.setAuthToken(authResponse.token!);
          await _storeUserData(authResponse.user!);
          
          return ApiResponse.success(authResponse.user!, authResponse.message);
        } else {
          // Rollback Firebase user creation if backend registration fails
          await firebaseCredential.user!.delete();
          return ApiResponse.error(
            authResponse.message ?? 'Registration failed'
          );
        }
      } else {
        // Rollback Firebase user creation if API call fails
        await firebaseCredential.user!.delete();
        return ApiResponse.error(response.error ?? 'Registration failed');
      }
    } on firebase.FirebaseAuthException catch (e) {
      return ApiResponse.error(_getFirebaseErrorMessage(e));
    } catch (e) {
      return ApiResponse.error('Registration failed: $e');
    }
  }

  // Login with email and password
  Future<ApiResponse<AuthUser>> login(LoginRequest request) async {
    try {
      // First, authenticate with Firebase
      final firebaseCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: request.email,
        password: request.password,
      );

      if (firebaseCredential.user == null) {
        return ApiResponse.error('Firebase authentication failed');
      }

      // Get Firebase ID token
      final idToken = await firebaseCredential.user!.getIdToken();

      // Login with backend API using Firebase ID token
      final response = await _apiService.post<AuthResponse>(
        '/auth/login',
        data: {
          'firebase_uid': firebaseCredential.user!.uid,
          'firebase_token': idToken,
          'email': request.email,
        },
        fromJson: (json) => AuthResponse.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        final authResponse = response.data!;
        
        if (authResponse.success && 
            authResponse.user != null && 
            authResponse.token != null) {
          
          // Store auth token and user data
          await _apiService.setAuthToken(authResponse.token!);
          await _storeUserData(authResponse.user!);
          
          return ApiResponse.success(authResponse.user!, authResponse.message);
        } else {
          return ApiResponse.error(
            authResponse.message ?? 'Login failed'
          );
        }
      } else {
        return ApiResponse.error(response.error ?? 'Login failed');
      }
    } on firebase.FirebaseAuthException catch (e) {
      return ApiResponse.error(_getFirebaseErrorMessage(e));
    } catch (e) {
      return ApiResponse.error('Login failed: $e');
    }
  }

  // Logout
  Future<ApiResponse<void>> logout() async {
    try {
      // Logout from backend
      await _apiService.post('/auth/logout');
      
      // Clear stored data
      await _apiService.clearAuthToken();
      await _clearUserData();
      
      // Sign out from Firebase
      await _firebaseAuth.signOut();
      
      return ApiResponse.success(null, 'Logged out successfully');
    } catch (e) {
      // Even if backend logout fails, clear local data
      await _apiService.clearAuthToken();
      await _clearUserData();
      await _firebaseAuth.signOut();
      
      return ApiResponse.success(null, 'Logged out successfully');
    }
  }

  // Reset password
  Future<ApiResponse<void>> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return ApiResponse.success(null, 'Password reset email sent');
    } on firebase.FirebaseAuthException catch (e) {
      return ApiResponse.error(_getFirebaseErrorMessage(e));
    } catch (e) {
      return ApiResponse.error('Failed to send reset email: $e');
    }
  }

  // Update profile
  Future<ApiResponse<AuthUser>> updateProfile(ProfileUpdateRequest request) async {
    try {
      final response = await _apiService.put<AuthResponse>(
        '/auth/profile',
        data: request.toJson(),
        fromJson: (json) => AuthResponse.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        final authResponse = response.data!;
        
        if (authResponse.success && authResponse.user != null) {
          // Update stored user data
          await _storeUserData(authResponse.user!);
          
          // Update Firebase profile if name changed
          if (request.name != null) {
            await currentFirebaseUser?.updateDisplayName(request.name);
          }
          
          return ApiResponse.success(authResponse.user!, authResponse.message);
        } else {
          return ApiResponse.error(
            authResponse.message ?? 'Profile update failed'
          );
        }
      } else {
        return ApiResponse.error(response.error ?? 'Profile update failed');
      }
    } catch (e) {
      return ApiResponse.error('Profile update failed: $e');
    }
  }

  // Change password
  Future<ApiResponse<void>> changePassword(ChangePasswordRequest request) async {
    try {
      // First, reauthenticate with Firebase
      final user = currentFirebaseUser;
      if (user == null || user.email == null) {
        return ApiResponse.error('User not authenticated');
      }

      final credential = firebase.EmailAuthProvider.credential(
        email: user.email!,
        password: request.currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update Firebase password
      await user.updatePassword(request.newPassword);

      // Update backend
      final response = await _apiService.post<Map<String, dynamic>>(
        '/auth/change-password',
        data: request.toJson(),
      );

      if (response.isSuccess) {
        return ApiResponse.success(null, 'Password changed successfully');
      } else {
        return ApiResponse.error(response.error ?? 'Password change failed');
      }
    } on firebase.FirebaseAuthException catch (e) {
      return ApiResponse.error(_getFirebaseErrorMessage(e));
    } catch (e) {
      return ApiResponse.error('Password change failed: $e');
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final firebaseUser = currentFirebaseUser;
    final hasApiToken = await _apiService.isAuthenticated();
    return firebaseUser != null && hasApiToken;
  }

  // Refresh authentication
  Future<ApiResponse<AuthUser>> refreshAuth() async {
    try {
      final firebaseUser = currentFirebaseUser;
      if (firebaseUser == null) {
        return ApiResponse.error('No Firebase user found');
      }

      // Get fresh Firebase ID token
      final idToken = await firebaseUser.getIdToken(true);

      // Refresh backend authentication
      final response = await _apiService.post<AuthResponse>(
        '/auth/refresh',
        data: {
          'firebase_uid': firebaseUser.uid,
          'firebase_token': idToken,
        },
        fromJson: (json) => AuthResponse.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        final authResponse = response.data!;
        
        if (authResponse.success && 
            authResponse.user != null && 
            authResponse.token != null) {
          
          // Update stored token and user data
          await _apiService.setAuthToken(authResponse.token!);
          await _storeUserData(authResponse.user!);
          
          return ApiResponse.success(authResponse.user!, authResponse.message);
        } else {
          return ApiResponse.error(
            authResponse.message ?? 'Authentication refresh failed'
          );
        }
      } else {
        return ApiResponse.error(response.error ?? 'Authentication refresh failed');
      }
    } catch (e) {
      return ApiResponse.error('Authentication refresh failed: $e');
    }
  }

  // Check if current user is admin
  Future<bool> isAdmin() async {
    try {
      final user = await getCurrentUser();
      return user?.isAdmin ?? false;
    } catch (e) {
      return false;
    }
  }

  // Verify user role from backend
  Future<ApiResponse<AuthUser>> verifyAuth() async {
    try {
      final response = await _apiService.get<AuthResponse>(
        '/auth/me',
        fromJson: (json) => AuthResponse.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        final authResponse = response.data!;
        
        if (authResponse.success && authResponse.user != null) {
          // Update stored user data with latest from server
          await _storeUserData(authResponse.user!);
          
          return ApiResponse.success(authResponse.user!, authResponse.message);
        } else {
          return ApiResponse.error(
            authResponse.message ?? 'Failed to verify authentication'
          );
        }
      } else {
        return ApiResponse.error(response.error ?? 'Failed to verify authentication');
      }
    } catch (e) {
      return ApiResponse.error('Failed to verify authentication: $e');
    }
  }

  // Get Firebase error message
  String _getFirebaseErrorMessage(firebase.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'Operation not allowed.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'requires-recent-login':
        return 'This operation requires recent login. Please login again.';
      default:
        return e.message ?? 'Authentication error occurred.';
    }
  }
}