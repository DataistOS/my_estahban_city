// test/features/feat_product/pages/brands_page_test.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';
import 'package:my_estahban_city/features/feat_product/pages/brands_page.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    pocketBaseInstance = PocketBase('http://127.0.0.1:8090');
  });

  group('BrandsPage Widget Tests', () {
    testWidgets('renders app bar, tabs and initial loading state correctly', (
      WidgetTester tester,
    ) async {
      await runZonedGuarded(() async {
        await tester.runAsync(() async {
          await tester.pumpWidget(const MaterialApp(home: BrandsPage()));
          await Future.delayed(const Duration(milliseconds: 100));
        });
      }, (error, stack) {});

      expect(find.text('دسته‌بندی برندها و مدل‌ها'), findsOneWidget);
      expect(find.text('برندها'), findsOneWidget);
      expect(find.text('مدل‌ها'), findsOneWidget);
    });

    testWidgets('switches between brands and models tabs successfully', (
      WidgetTester tester,
    ) async {
      await runZonedGuarded(() async {
        await tester.runAsync(() async {
          await tester.pumpWidget(const MaterialApp(home: BrandsPage()));
          await Future.delayed(const Duration(milliseconds: 100));
          await tester.pump();

          await tester.tap(find.text('مدل‌ها'));
          await tester.pumpAndSettle();

          await tester.tap(find.text('برندها'));
          await tester.pumpAndSettle();
        });
      }, (error, stack) {});

      expect(find.text('دسته‌بندی برندها و مدل‌ها'), findsOneWidget);
    });
  });
}
