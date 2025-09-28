import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../services/auth_service.dart';

class RouterService {
  static GoRouter? _router;
  static GoRouter get router {
    _router ??= GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: '/',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        // Deep linking routes for gopipit.com
        GoRoute(
          path: '/pipit/:action',
          name: 'pipit_action',
          builder: (context, state) {
            final action = state.pathParameters['action'];
            switch (action) {
              case 'profile':
                return const ProfileScreen();
              case 'settings':
                return const SettingsScreen();
              default:
                return const HomeScreen();
            }
          },
        ),
      ],
      // Handle deep links and authentication redirects
      redirect: (context, state) async {
        final location = state.matchedLocation;
        // Handle gopipit.com deep linking
        if (state.uri.host == 'gopipit.com' || 
            state.uri.host == 'staging.gopipit.com') {
          final path = state.uri.path;
          if (path.startsWith('/pipit/')) {
            return path;
          }
        }
        // Allow splash screen without authentication check
        if (location == '/') {
          return null;
        }
        // For now, allow all navigation - authentication will be checked in splash
        return null;
      },
    );
    return _router!;
  }
  static void clearRouter() {
    _router = null;
  }
}