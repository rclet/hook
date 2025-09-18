import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'services/api_service.dart';
import 'services/router_service.dart';
import 'utils/theme.dart';

void main() {
  runApp(const PipitApp());
}

class PipitApp extends StatelessWidget {
  const PipitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // iPhone X design size
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return MaterialApp.router(
            title: 'Pipit - Nupuit',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: RouterService.router,
          );
        },
      ),
    );
  }
}