import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pipit/main.dart';

void main() {
  group('Pipit App Tests', () {
    testWidgets('App should start with splash screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const PipitApp());

      // Verify that splash screen is shown initially
      expect(find.text('Pipit'), findsOneWidget);
      expect(find.text('Nupuit Platform'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('App navigation should work', (WidgetTester tester) async {
      await tester.pumpWidget(const PipitApp());
      
      // Wait for splash screen timeout
      await tester.pumpAndSettle(const Duration(seconds: 4));
      
      // Should navigate to home screen
      expect(find.text('Welcome to Pipit'), findsOneWidget);
    });

    testWidgets('Theme should be applied correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const PipitApp());
      
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      
      // Verify theme is applied
      expect(materialApp.theme, isNotNull);
      expect(materialApp.theme!.fontFamily, 'SolaimanLipi');
    });
  });
}