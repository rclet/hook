# Pipit - Nupuit Platform

Pipit is a mobile-first Flutter application for the Nupuit freelance platform, integrating with the Rclet API hosted at `gig.com.bd/gig-main/backend/public/api`. This app enables users to discover, browse, and order freelance services (gigs) through an intuitive mobile interface.

## 🚀 Features

- **Mobile-First Design**: Optimized for mobile devices with responsive design using `flutter_screenutil`
- **Modern Navigation**: Implemented with `go_router` for efficient routing and deep linking
- **API Integration**: Connects to Rclet API for real-time gig data
- **Deep Linking**: Supports `gopipit.com` deep linking for enhanced user experience  
- **Progressive Web App**: Web build optimized for deployment
- **Multi-language Support**: Uses Solaiman Lipi font for Bengali text support
- **CI/CD Pipeline**: Automated testing, building, and deployment

## 🏗️ Architecture

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models (User, Gig, ApiResponse)
├── screens/                  # UI screens (Home, Profile, Settings, Splash)
├── services/                 # Business logic (API, Router services)
├── utils/                    # Utilities (Theme, constants)
└── widgets/                  # Reusable widgets (GigCard, etc.)
```

## 🛠️ Tech Stack

- **Frontend**: Flutter 3.19.0+
- **State Management**: Provider
- **Navigation**: go_router  
- **HTTP Client**: http package
- **UI**: Material Design 3 with custom theme
- **Responsive Design**: flutter_screenutil
- **API**: Rclet API integration
- **CI/CD**: GitHub Actions
- **Deployment**: Web to Namecheap hosting

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

### Production Deployment (gopipit.com)

1. **Automated via CI/CD**:
   - Push to `main` branch triggers production deployment
   - Build artifacts deployed to `public_html/pipit/`

2. **Manual Deployment**:
   ```bash
   flutter build web --release --base-href "/pipit/"
   cp -r build/web/* public_html/pipit/
   ```

### Staging Deployment (staging.gopipit.com)

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

- `gopipit.com/pipit/profile` → User profile
- `gopipit.com/pipit/settings` → App settings  
- `staging.gopipit.com/profile` → Staging profile
- `staging.gopipit.com/settings` → Staging settings

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
https://gig.com.bd/gig-main/backend/public/api
```

Supported endpoints:
- `GET /gigs` - Fetch available gigs
- `GET /users/{id}` - Get user details
- `POST /orders` - Create new orders

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
