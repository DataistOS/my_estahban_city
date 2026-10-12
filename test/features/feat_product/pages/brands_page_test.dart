// test/features/feat_product/pages/brands_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_estahban_city/features/feat_product/pages/brands_page.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('BrandsPage Widget Tests', () {
    testWidgets('renders app bar, tabs and initial loading state correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: BrandsPage()));

      expect(find.text('دسته‌بندی برندها و مدل‌ها'), findsOneWidget);
      expect(find.text('برندها'), findsOneWidget);
      expect(find.text('مدل‌ها'), findsOneWidget);

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('switches between brands and models tabs successfully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: BrandsPage()));

      await tester.pump();

      await tester.tap(find.text('مدل‌ها'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('برندها'));
      await tester.pumpAndSettle();

      expect(find.text('دسته‌بندی برندها و مدل‌ها'), findsOneWidget);
    });
  });
}
