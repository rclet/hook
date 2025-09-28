import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pipit/screens/settings_screen.dart';

void main() {
  group('SettingsScreen Debug APK Sharing Tests', () {
    testWidgets('Debug APK option should be visible in developer options', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) => const SettingsScreen(),
          ),
        ),
      );

      // In debug mode, developer options should be visible
      expect(find.text('Developer Options'), findsOneWidget);
      
      // The Debug APK sharing option should be present
      expect(find.text('Share Debug APK'), findsOneWidget);
      expect(find.text('Download and share debug version'), findsOneWidget);
    });

    testWidgets('Debug APK dialog should show when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) => const SettingsScreen(),
          ),
        ),
      );

      // Find and tap the Share Debug APK option
      await tester.tap(find.text('Share Debug APK'));
      await tester.pumpAndSettle();

      // Dialog should appear with correct title and content
      expect(find.text('Debug APK'), findsOneWidget);
      expect(find.text('Debug APKs are available for testing'), findsOneWidget);
      expect(find.text('Available Builds:'), findsOneWidget);
      expect(find.text('• Development (dev) - Latest features'), findsOneWidget);
      expect(find.text('• Staging - Pre-release testing'), findsOneWidget);

      // Action buttons should be present
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Copy Info'), findsOneWidget);
      expect(find.text('Download'), findsOneWidget);
    });

    testWidgets('Copy Info should work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) => const SettingsScreen(),
          ),
        ),
      );

      // Open the debug APK dialog
      await tester.tap(find.text('Share Debug APK'));
      await tester.pumpAndSettle();

      // Tap Copy Info button
      await tester.tap(find.text('Copy Info'));
      await tester.pumpAndSettle();

      // Should show success message
      expect(find.text('Debug APK information copied to clipboard'), findsOneWidget);
    });
  });
}