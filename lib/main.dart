import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'config/environment.dart';
import 'services/enhanced_api_service.dart';
import 'services/auth_service.dart';
import 'services/business_services.dart';
import 'services/router_service.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set environment (can be changed based on build configuration)
  AppConfig.setEnvironment(Environment.dev);
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  runApp(const PipitApp());
}

class PipitApp extends StatelessWidget {
  const PipitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // API Service
        Provider<ApiService>(
          create: (_) => ApiService(),
          dispose: (_, service) => service.dispose(),
        ),
        
        // Auth Service
        ProxyProvider<ApiService, AuthService>(
          create: (context) => AuthService(context.read<ApiService>()),
          update: (context, apiService, _) => AuthService(apiService),
        ),
        
        // Business Services
        ProxyProvider<ApiService, GigService>(
          create: (context) => GigService(context.read<ApiService>()),
          update: (context, apiService, _) => GigService(apiService),
        ),
        
        ProxyProvider<ApiService, CategoryService>(
          create: (context) => CategoryService(context.read<ApiService>()),
          update: (context, apiService, _) => CategoryService(apiService),
        ),
        
        ProxyProvider<ApiService, OrderService>(
          create: (context) => OrderService(context.read<ApiService>()),
          update: (context, apiService, _) => OrderService(apiService),
        ),
        
        ProxyProvider<ApiService, NotificationService>(
          create: (context) => NotificationService(context.read<ApiService>()),
          update: (context, apiService, _) => NotificationService(apiService),
        ),
        
        ProxyProvider<ApiService, PaymentService>(
          create: (context) => PaymentService(context.read<ApiService>()),
          update: (context, apiService, _) => PaymentService(apiService),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // iPhone X design size
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return MaterialApp.router(
            title: AppConfig.appName,
            debugShowCheckedModeBanner: AppConfig.isDebug,
            theme: AppTheme.lightTheme,
            routerConfig: RouterService.router,
          );
        },
      ),
    );
  }
}