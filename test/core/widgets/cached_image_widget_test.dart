// test/core/widgets/cached_image_widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_estahban_city/core/widgets/cached_image_widget.dart';

void main() {
  group('CachedImageWidget Tests', () {
    testWidgets(
      'renders broken image placeholder when imageUrl is empty or blank',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: CachedImageWidget(imageUrl: '   ')),
          ),
        );

        expect(find.byIcon(Icons.broken_image), findsOneWidget);
      },
    );

    testWidgets(
      'renders ClipRRect when borderRadius is provided with valid url',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CachedImageWidget(
                imageUrl: 'https://example.com/image.jpg',
                width: 100,
                height: 100,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        );

        expect(find.byType(CachedImageWidget), findsOneWidget);
        expect(find.byType(ClipRRect), findsOneWidget);
      },
    );
  });
}
