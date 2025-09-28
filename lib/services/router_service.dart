import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';

class RouterService {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
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
    // Handle deep links for gopipit.com
    redirect: (context, state) {
      final location = state.matchedLocation;
      
      // Handle gopipit.com deep linking
      if (state.uri.host == 'gopipit.com' || 
          state.uri.host == 'staging.gopipit.com') {
        // Extract path and redirect appropriately
        final path = state.uri.path;
        if (path.startsWith('/pipit/')) {
          return path;
        }
        return '/home';
      }
      
      return null; // No redirect needed
    },
  );
}