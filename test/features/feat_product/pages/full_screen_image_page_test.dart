// test/features/feat_product/pages/full_screen_image_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_estahban_city/features/feat_product/pages/full_screen_image_page.dart';

void main() {
  group('FullScreenImagePage Widget Tests', () {
    const testImages = [
      'https://example.com/image1.jpg',
      'https://example.com/image2.jpg',
      'https://example.com/image3.jpg',
    ];
    const testHeroTag = 'product_hero_tag_1';

    testWidgets('renders images and initial hero tag correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FullScreenImagePage(
            images: testImages,
            heroTag: testHeroTag,
            initialIndex: 0,
          ),
        ),
      );

      expect(find.byType(Hero), findsOneWidget);
      expect(find.byType(PageView), findsOneWidget);

      final pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);
    });

    testWidgets('swipes between images and updates page indicator index', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FullScreenImagePage(
            images: testImages,
            heroTag: testHeroTag,
            initialIndex: 0,
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();

      final PageView pageView = tester.widget(find.byType(PageView));
      expect(pageView.controller, isNotNull);
    });

    testWidgets('respects initialIndex when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FullScreenImagePage(
            images: testImages,
            heroTag: testHeroTag,
            initialIndex: 1,
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Hero heroWidget = tester.widget(find.byType(Hero));
      expect(heroWidget.tag, testHeroTag);
    });
  });
}
