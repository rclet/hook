# Hook App Backend API Integration Guide

## Overview
This document provides comprehensive instructions for setting up and maintaining the Hook app's backend API integration with Firebase authentication and the Rclet API.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Environment Configuration](#environment-configuration)
3. [Firebase Setup](#firebase-setup)
4. [API Configuration](#api-configuration)
5. [Authentication Flow](#authentication-flow)
6. [Testing & Demo Accounts](#testing--demo-accounts)
7. [Payment Integration](#payment-integration)
8. [Deployment](#deployment)
9. [Troubleshooting](#troubleshooting)

## Prerequisites

### Development Environment
- Flutter 3.19.0 or higher
- Dart 3.0.0 or higher
- Firebase CLI
- Android Studio / VS Code
- Git

### Dependencies
The following packages are required (already added to `pubspec.yaml`):
```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  dio: ^5.4.0
  flutter_secure_storage: ^9.0.0
  go_router: ^14.2.7
  provider: ^6.1.1
  json_annotation: ^4.8.1
  flutter_screenutil: ^5.9.3
```

## Environment Configuration

### Setting Up Environments
The app supports three environments: `dev`, `staging`, and `prod`. Configuration is managed in `lib/config/environment.dart`.

#### Changing Environment
In `lib/main.dart`, update the environment setting:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Change this based on your target environment
  AppConfig.setEnvironment(Environment.dev);    // For development
  AppConfig.setEnvironment(Environment.staging); // For staging
  AppConfig.setEnvironment(Environment.prod);    // For production
  
  await Firebase.initializeApp();
  runApp(const PipitApp());
}
```

#### API Base URL Configuration
All environments currently point to the same API:
```
https://gig.com.bd/gig-main/backend/api
```

To use different endpoints for different environments, modify `lib/config/environment.dart`:
```dart
static String get apiBaseUrl {
  switch (_environment) {
    case Environment.dev:
      return 'https://dev-api.gig.com.bd/gig-main/backend/api';
    case Environment.staging:
      return 'https://staging-api.gig.com.bd/gig-main/backend/api';
    case Environment.prod:
      return 'https://gig.com.bd/gig-main/backend/api';
  }
}
```

## Firebase Setup

### 1. Create Firebase Projects
Create separate Firebase projects for each environment:
- `pipit-dev` - Development
- `pipit-staging` - Staging  
- `pipit-prod` - Production

### 2. Enable Authentication
In each Firebase project:
1. Go to Authentication → Sign-in method
2. Enable **Email/Password** authentication
3. Configure authorized domains if needed

### 3. Download Configuration Files
For each platform and environment:

#### Android
1. Download `google-services.json` for each environment
2. Place in `android/app/src/` directories:
   - `android/app/src/dev/google-services.json`
   - `android/app/src/staging/google-services.json`  
   - `android/app/src/prod/google-services.json`

#### iOS
1. Download `GoogleService-Info.plist` for each environment
2. Add to iOS project with appropriate targets

### 4. Configure Build Variants (Android)
Add to `android/app/build.gradle`:
```gradle
android {
    flavorDimensions "environment"
    
    productFlavors {
        dev {
            dimension "environment"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
        }
        staging {
            dimension "environment"
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
        }
        prod {
            dimension "environment"
        }
    }
}
```

## API Configuration

### Backend API Requirements
The backend API must support the following endpoints for full integration:

#### Authentication Endpoints
```
POST /auth/register
POST /auth/login
POST /auth/logout
POST /auth/refresh
PUT  /auth/profile
POST /auth/change-password
```

#### Core Business Endpoints
```
GET  /gigs
GET  /gigs/{id}
GET  /gigs/featured
GET  /gigs/my-gigs
POST /gigs

GET  /categories

POST /orders
GET  /orders/my-orders
GET  /orders/seller-orders
GET  /orders/{id}
PUT  /orders/{id}/status

GET  /notifications
PUT  /notifications/{id}/mark-read
PUT  /notifications/mark-all-read
GET  /notifications/unread-count

POST /payments
POST /payments/bkash/create
POST /payments/bkash/execute
POST /payments/bkash/query
GET  /payments/my-payments
```

### Authentication Headers
The app automatically includes authentication headers:
```
Authorization: Bearer {firebase_id_token}
```

### Request/Response Format
All API responses should follow this format:
```json
{
  "success": true,
  "message": "Success message",
  "data": { ... }
}
```

Error responses:
```json
{
  "success": false,
  "message": "Error message",
  "errors": { 
    "field": ["Validation error message"]
  }
}
```

## Authentication Flow

### User Registration
1. User fills registration form
2. App creates Firebase user with email/password
3. App gets Firebase ID token
4. App sends registration data + Firebase UID + ID token to backend
5. Backend validates Firebase token and creates user record
6. Backend returns user data + JWT token (optional, can rely on Firebase tokens)

### User Login
1. User provides email/password
2. App authenticates with Firebase
3. App gets Firebase ID token
4. App sends Firebase UID + ID token to backend
5. Backend validates token and returns user data

### Token Management
- Firebase ID tokens are automatically refreshed
- Secure storage is used for token persistence
- Automatic logout on token expiry or 401 errors

## Testing & Demo Accounts

### Creating Test Accounts
Use the registration screen to create test accounts with the following pattern:
```
Email: test+dev1@example.com
Password: Test123!
Name: Test User 1

Email: test+dev2@example.com  
Password: Test123!
Name: Test User 2
```

### Demo Data Requirements
The backend should have demo data including:
- Sample gigs in various categories
- Demo payment transactions
- Test notifications
- Sample reviews and ratings

### Payment Testing
For bKash integration testing:
1. Use sandbox/demo credentials
2. Test phone numbers: +8801777777777
3. Test amounts: Use amounts that trigger different responses

## Payment Integration

### bKash Configuration
The app includes demo bKash payment integration. Configure in backend:

```json
{
  "bkash": {
    "base_url": "https://tokenized.sandbox.bka.sh/v1.2.0-beta",
    "username": "sandbox_username",
    "password": "sandbox_password", 
    "app_key": "sandbox_app_key",
    "app_secret": "sandbox_app_secret"
  }
}
```

### Payment Flow
1. User selects bKash payment
2. App calls `/payments/bkash/create`
3. App redirects to bKash payment URL
4. User completes payment on bKash
5. App calls `/payments/bkash/execute`
6. Payment status updated in database

## Deployment

### Development Build
```bash
# Set environment to dev in main.dart first
flutter build apk --debug --flavor dev
```

### Staging Build  
```bash
# Set environment to staging in main.dart first
flutter build apk --release --flavor staging
```

### Production Build
```bash
# Set environment to prod in main.dart first
flutter build apk --release --flavor prod
```

### Web Deployment
```bash
flutter build web --release --base-href "/pipit/"
```

## Troubleshooting

### Common Issues

#### Firebase Authentication Errors
- **Error**: "FirebaseApp not initialized"
  - **Solution**: Ensure `Firebase.initializeApp()` is called in main()

- **Error**: "Invalid API key"
  - **Solution**: Check `google-services.json` is correctly placed

#### API Connection Issues
- **Error**: "Network error" or timeouts
  - **Solution**: Check API base URL in `lib/config/environment.dart`
  - **Solution**: Verify network connectivity and API availability

#### Token Issues
- **Error**: "Unauthorized" (401) responses
  - **Solution**: Check Firebase token is being sent correctly
  - **Solution**: Verify backend token validation

#### Build Issues  
- **Error**: "Failed to resolve dependency"
  - **Solution**: Run `flutter pub get` and `flutter clean`

### Debug Mode
Enable debug logging by setting environment to `dev`. This will show:
- API request/response details
- Authentication token information
- Error details

### Logs Location
- **Android**: Use `flutter logs` or Android Studio Logcat
- **iOS**: Use Xcode Console
- **Web**: Browser Developer Tools Console

## Maintenance

### Regular Tasks
1. **Update Dependencies**: Monthly check for package updates
2. **Firebase Token Rotation**: Monitor token expiry patterns
3. **API Monitoring**: Check endpoint response times and errors
4. **Security Updates**: Keep Firebase and security packages updated

### Monitoring
Monitor the following metrics:
- Authentication success/failure rates
- API response times
- Payment success rates
- User registration patterns
- Error frequencies

### Backup Procedures
1. **User Data**: Ensure backend has proper backup procedures
2. **Firebase Configuration**: Keep configuration files in secure version control
3. **API Keys**: Store securely and rotate regularly

## Support

For issues or questions:
- **Code Issues**: Check GitHub repository issues
- **Firebase Issues**: Firebase Console Support
- **API Issues**: Contact backend development team
- **Payment Issues**: bKash merchant support

## Version History
- **v1.0.0**: Initial integration with Firebase Auth and Rclet API
- **v1.0.1**: Added comprehensive error handling and loading states
- **v1.1.0**: Enhanced profile management and payment integration