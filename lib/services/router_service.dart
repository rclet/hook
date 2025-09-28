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
        // Splash screen
        GoRoute(
          path: '/',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        
        // Authentication routes
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
        
        // Protected routes
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
        
        // Deep linking routes for pipitgo.com
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
        
        // Handle pipitgo.com deep linking
        if (state.uri.host == 'pipitgo.com' || 
            state.uri.host == 'staging.pipitgo.com') {
          final path = state.uri.path;
          if (path.startsWith('/pipit/')) {
            return path;
          }
        }
        
        // Check authentication status for protected routes
        final protectedRoutes = ['/home', '/profile', '/settings'];
        final authRoutes = ['/login', '/register'];
        
        // Allow splash screen without authentication check
        if (location == '/') {
          return null;
        }
        
        // Try to get auth service, but handle gracefully if not available
        try {
          // Note: We can't easily access the auth service here without context
          // The splash screen will handle the authentication check
          
          // If trying to access auth routes and already authenticated, redirect to home
          // This will be handled by individual screens
          
          // For now, allow all navigation - authentication will be checked in splash
          return null;
        } catch (e) {
          // If we can't check auth status, allow navigation
          return null;
        }
      },
    );
    
    return _router!;
  }
  
  // Clear router instance (useful for testing)
  static void clearRouter() {
    _router = null;
  }
}