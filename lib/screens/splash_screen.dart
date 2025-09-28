import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../config/environment.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _animationController.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Show splash for at least 2 seconds
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Check authentication status
      final authService = context.read<AuthService>();
      final isAuthenticated = await authService.isAuthenticated();

      if (mounted) {
        if (isAuthenticated) {
          // User is authenticated, go to home
          context.go('/home');
        } else {
          // User is not authenticated, go to login
          context.go('/login');
        }
      }
    } catch (e) {
      // On error, default to login screen
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Enhanced Pipit Logo/Icon with better design
                Container(
                  width: 140.w,
                  height: 140.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(70.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.flight_takeoff_rounded,
                    size: 70.sp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                
                SizedBox(height: 32.h),
                
                // Enhanced app title with better typography
                Text(
                  'Pipit',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                  ),
                ),
                
                SizedBox(height: 8.h),
                
                // Enhanced subtitle with better spacing
                Text(
                  'Nupuit Platform',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                
                SizedBox(height: 64.h),
                
                // Enhanced loading indicator
                Container(
                  width: 48.w,
                  height: 48.h,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.9),
                    ),
                    strokeWidth: 3,
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Loading text with animation
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Text(
                      'Loading...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.7 * _fadeAnimation.value),
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}