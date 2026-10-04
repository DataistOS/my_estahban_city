// test/features/feat_about/pages/about_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_estahban_city/features/feat_about/pages/about_page.dart';

void main() {
  Widget createTestableWidget() {
    return const MaterialApp(home: AboutPage());
  }

  group('AboutPage Widget Tests', () {
    testWidgets('should render app bar and main section cards correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());

      expect(find.text('درباره ما'), findsWidgets);

      expect(find.text('شرکت آزاداندیش داده‌ساز'), findsOneWidget);
      expect(find.text('خدمات و محدوده وظایف'), findsOneWidget);
      expect(find.text('پیوند به خدمات'), findsOneWidget);
    });

    testWidgets('should display services and bullet items properly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());

      // بررسی برخی از خدمات ذکر شده در لیست
      expect(find.text('سرویس‌دهی به سامانه‌‌های شهروندی'), findsOneWidget);
      expect(
        find.text('توسعه و مشارکت در سیستم‌عامل دیتائیست'),
        findsOneWidget,
      );
      expect(find.text('بهینه‌سازی مشاغل با هوش مصنوعی'), findsOneWidget);
    });

    testWidgets(
      'should display link categories and trigger link tap without crashing',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestableWidget());

        expect(find.text('# EstahbanLug.ir'), findsOneWidget);
        expect(find.text('# Dataist.ir'), findsOneWidget);

        final linkFinder = find.text('https://dataist.ir');
        expect(linkFinder, findsOneWidget);

        await tester.tap(linkFinder);
        await tester.pump();

        expect(find.text('درباره ما'), findsWidgets);
      },
    );
  });
}
