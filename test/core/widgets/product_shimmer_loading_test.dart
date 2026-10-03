// test/core/widgets/product_shimmer_loading_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';
import 'package:my_estahban_city/core/widgets/product_shimmer_loading.dart';

void main() {
  group('ProductShimmerLoading Tests', () {
    testWidgets(
      'renders shimmer loading widget correctly with card and structure',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ProductShimmerLoading())),
        );

        expect(find.byType(Shimmer), findsOneWidget);
        expect(find.byType(Card), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
      },
    );
  });
}
