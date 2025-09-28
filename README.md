# Pipit - Nupuit Platform

Pipit is a mobile-first Flutter application for the Nupuit freelance platform, integrating with the Rclet API hosted at `gig.com.bd/gig-main/backend/public/api`. This app enables users to discover, browse, and order freelance services (gigs) through an intuitive mobile interface.

## 🚀 Features

- **🔐 Firebase Authentication**: Secure user registration and login with independent user base
- **📱 Mobile-First Design**: Optimized for mobile devices with responsive design using `flutter_screenutil`
- **🚀 Modern Navigation**: Implemented with `go_router` for efficient routing and deep linking
- **🌐 Robust API Integration**: Enhanced Dio-based HTTP client with automatic authentication
- **🔄 Real-time Data**: Live updates for gigs, orders, and notifications
- **🎨 Pixel-Perfect UI**: Material Design 3 with custom theming and animations
- **🔍 Advanced Search**: Category filtering, price ranges, and keyword search
- **💳 Payment Integration**: bKash payment gateway with demo/test endpoints
- **📊 User Dashboard**: Profile management, order tracking, and gig management
- **🔔 Push Notifications**: Real-time notifications for orders and messages
- **🌐 Multi-Environment**: Separate dev, staging, and production configurations
- **🔒 Secure Storage**: Encrypted storage for authentication tokens and sensitive data
- **📚 Deep Linking**: Supports `pipitgo.com` deep linking for enhanced user experience
- **⚡ Progressive Web App**: Web build optimized for deployment
- **🌍 Multi-language Ready**: Architecture supports internationalization
- **🚀 CI/CD Pipeline**: Automated testing, building, and deployment

## 🏗️ Architecture

```
lib/
├── main.dart                    # App entry point with Firebase initialization
├── config/
│   └── environment.dart         # Environment configuration (dev/staging/prod)
├── models/
│   ├── api_response.dart        # Legacy API response wrapper
│   ├── auth_models.dart         # Authentication models (login/register/profile)
│   ├── auth_models.g.dart       # Generated JSON serialization
│   ├── models.dart              # Business models (Orders, Payments, etc.)
│   └── models.g.dart            # Generated JSON serialization
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart    # User login with Firebase
│   │   └── register_screen.dart # User registration with validation
│   ├── home_screen.dart         # Main dashboard with gig listings
│   ├── profile_screen.dart      # User profile with edit functionality
│   ├── settings_screen.dart     # App settings and preferences
│   └── splash_screen.dart       # Authentication flow handler
├── services/
│   ├── api_service.dart         # Legacy basic HTTP service
│   ├── enhanced_api_service.dart # New Dio-based HTTP client
│   ├── auth_service.dart        # Firebase + Backend authentication
│   ├── business_services.dart   # Gig, Order, Payment, Notification services
│   └── router_service.dart      # Navigation with auth guards
├── utils/
│   └── theme.dart               # Material Design 3 theming
└── widgets/
    └── gig_card.dart            # Reusable gig display components
```

## 🛠️ Tech Stack

- **Frontend**: Flutter 3.19.0+
- **Authentication**: Firebase Auth (independent user base)
- **State Management**: Provider pattern with dependency injection
- **Navigation**: go_router with authentication guards
- **HTTP Client**: Dio with automatic authentication and error handling  
- **Secure Storage**: flutter_secure_storage for tokens and sensitive data
- **UI Framework**: Material Design 3 with custom theme
- **Responsive Design**: flutter_screenutil for pixel-perfect scaling
- **Serialization**: json_annotation with code generation
- **API Integration**: Rclet API with comprehensive error handling
- **Payment Gateway**: bKash integration with demo endpoints
- **CI/CD**: GitHub Actions with automated testing and deployment
- **Deployment**: Web to Namecheap hosting with environment-specific builds

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS  
- ✅ Web (PWA)
- 🔄 Desktop (planned)

## 🚀 Getting Started

### Prerequisites

- Flutter 3.19.0 or higher
- Dart 3.0.0 or higher
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/rclet/hook.git
   cd hook
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Install Solaiman Lipi font**
   - Download Solaiman Lipi font files
   - Place `SolaimanLipi.ttf` and `SolaimanLipi-Bold.ttf` in `assets/pipit/fonts/`

4. **Run the app**
   ```bash
   # Development mode
   flutter run
   
   # Web development
   flutter run -d chrome
   
   # Release build
   flutter run --release
   ```

### Building for Production

**Android APK:**
```bash
flutter build apk --release
```

**Web Build:**
```bash
flutter build web --release --base-href "/pipit/"
```

**iOS (macOS only):**
```bash
flutter build ios --release
```

## 🌐 Deployment

### Production Deployment (pipitgo.com)

1. **Automated via CI/CD**:
   - Push to `main` branch triggers production deployment
   - Build artifacts deployed to `public_html/pipit/`

2. **Manual Deployment**:
   ```bash
   flutter build web --release --base-href "/pipit/"
   cp -r build/web/* public_html/pipit/
   ```

### Staging Deployment (staging.pipitgo.com)

1. **Automated via CI/CD**:
   - Push to `develop` branch triggers staging deployment
   - Build artifacts deployed to `public_html/staging/`

2. **Manual Deployment**:
   ```bash
   flutter build web --release
   cp -r build/web/* public_html/staging/
   ```

## 🔗 Deep Linking

The app supports deep linking for enhanced user experience:

- `pipitgo.com/pipit/profile` → User profile
- `pipitgo.com/pipit/settings` → App settings  
- `staging.pipitgo.com/profile` → Staging profile
- `staging.pipitgo.com/settings` → Staging settings

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

## 📊 Code Quality

```bash
# Format code
dart format .

# Analyze code
dart analyze

# Fix common issues
dart fix --apply
```

## 🚀 CI/CD Pipeline

The GitHub Actions workflow includes:

- ✅ **Code Quality**: Formatting, linting, analysis
- ✅ **Testing**: Unit tests, widget tests  
- ✅ **Security**: Vulnerability scanning with Trivy
- ✅ **Building**: Android APK and Web builds
- ✅ **Deployment**: Automated staging and production deployment
- ✅ **Performance**: Lighthouse performance testing

## 🔧 Configuration

### Environment Variables

- `FLUTTER_VERSION`: Flutter version for CI/CD
- `API_BASE_URL`: Rclet API base URL (default: `https://gig.com.bd/gig-main/backend/public/api`)

### API Configuration

The app integrates with the Rclet API at:
```
https://gig.com.bd/gig-main/backend/api
```

#### Environment Configuration
The app supports multiple environments (dev, staging, prod) configured in `lib/config/environment.dart`. Change the environment in `lib/main.dart`:

```dart
// Set environment before Firebase initialization
AppConfig.setEnvironment(Environment.dev);    // For development
AppConfig.setEnvironment(Environment.staging); // For staging  
AppConfig.setEnvironment(Environment.prod);    // For production
```

#### Authentication Integration
- **Firebase Authentication**: Independent user base with email/password
- **Secure Token Storage**: Uses flutter_secure_storage for token persistence
- **Automatic Token Refresh**: Firebase ID tokens refreshed automatically
- **Backend Integration**: Firebase tokens sent to backend API for validation

#### Supported API Endpoints
**Authentication:**
- `POST /auth/register` - User registration with Firebase integration
- `POST /auth/login` - User login with Firebase validation
- `POST /auth/logout` - User logout
- `PUT /auth/profile` - Profile updates
- `POST /auth/change-password` - Password changes

**Core Features:**
- `GET /gigs` - Fetch gigs with filtering and search
- `GET /gigs/featured` - Featured gigs
- `GET /gigs/my-gigs` - User's own gigs
- `POST /orders` - Create orders
- `GET /orders/my-orders` - User order history
- `GET /notifications` - User notifications
- `POST /payments/bkash/*` - bKash payment integration (demo/test)

#### Request Format
All authenticated requests automatically include:
```
Authorization: Bearer {firebase_id_token}
Content-Type: application/json
```

#### Error Handling
- Comprehensive error handling for all HTTP status codes
- Automatic token refresh on expiry
- User-friendly error messages
- Retry mechanisms for network failures

## 🎨 Design System

### Colors
- **Primary**: `#2E7D8F` (Teal)
- **Secondary**: `#5FB3C6` (Light Teal)  
- **Accent**: `#FFB74D` (Amber)
- **Background**: `#F8F9FA` (Light Gray)

### Typography
- **Font Family**: Solaiman Lipi (Bengali/English support)
- **Responsive Sizing**: Uses `flutter_screenutil` for consistent scaling

### Components
- Material Design 3 components
- Custom widgets for gig cards, user profiles
- Responsive layouts for mobile-first experience

## 📚 Documentation

- [API Documentation](docs/api.md)
- [Deployment Guide](docs/deployment.md)  
- [Contributing Guidelines](docs/contributing.md)
- [Agent Readiness Guide](docs/agent-readiness.md)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/rclet/hook/issues)
- **Documentation**: [Project Wiki](https://github.com/rclet/hook/wiki)
- **Email**: support@nupuit.com

## 🔄 Roadmap

- [ ] **Phase 1** (Current): Core functionality, API integration
- [ ] **Phase 2**: Enhanced user profiles, messaging system  
- [ ] **Phase 3**: Payment integration, advanced search
- [ ] **Phase 4**: AI-powered recommendations, analytics

## 🙏 Acknowledgments

- Flutter team for the excellent framework
- Rclet API team for backend services
- Nupuit platform for the business requirements
- Open source community for the amazing packages

---

**Built with ❤️ using Flutter for Nupuit Platform**
