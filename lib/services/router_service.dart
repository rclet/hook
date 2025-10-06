import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/admin_users_screen.dart';
import '../services/auth_service.dart';

class RouterService {
  static GoRouter createRouter() {
    return GoRouter(
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
        // Admin routes
        GoRoute(
          path: '/admin',
          name: 'admin',
          builder: (context, state) => const AdminDashboardScreen(),
        ),
        GoRoute(
          path: '/admin/users',
          name: 'admin_users',
          builder: (context, state) => const AdminUsersScreen(),
        ),
        GoRoute(
          path: '/admin/gigs',
          name: 'admin_gigs',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Admin Gigs - Coming Soon')),
          ),
        ),
        GoRoute(
          path: '/admin/orders',
          name: 'admin_orders',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Admin Orders - Coming Soon')),
          ),
        ),
        GoRoute(
          path: '/admin/settings',
          name: 'admin_settings',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Admin Settings - Coming Soon')),
          ),
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
      // Handle deep links and admin route guards
      redirect: (context, state) async {
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
        
        // Admin route guard
        if (location.startsWith('/admin')) {
          try {
            final authService = context.read<AuthService>();
            
            // Check if user is authenticated
            final isAuth = await authService.isAuthenticated();
            if (!isAuth) {
              return '/login';
            }
            
            // Verify admin role from backend
            final verifyResponse = await authService.verifyAuth();
            if (!verifyResponse.isSuccess || verifyResponse.data == null) {
              return '/login';
            }
            
            // Check if user has admin role
            final user = verifyResponse.data!;
            if (!user.isAdmin) {
              return '/home'; // Redirect non-admin users to home
            }
          } catch (e) {
            return '/login';
          }
        }
        
        return null; // No redirect needed
      },
    );
  }
  
  // For backward compatibility
  static final GoRouter router = createRouter();
}