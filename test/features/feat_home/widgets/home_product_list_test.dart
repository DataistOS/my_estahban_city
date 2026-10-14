// test/features/feat_home/widgets/home_product_list_test.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_estahban_city/features/feat_home/widgets/home_product_list.dart';
import 'package:my_estahban_city/features/feat_product/models/product_model.dart';
import 'package:my_estahban_city/core/widgets/no_connection_widget.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  ProductModel createDummyProduct({
    required String id,
    required String name,
    double price = 100000.0,
  }) {
    return ProductModel(
      id: id,
      name: name,
      description: 'توضیحات تست',
      price: price,
      stock: 5.0,
      category: 'cat1',
      mainImage: '',
      galleryImages: [],
      isAvailable: true,
      created: DateTime.now(),
      updated: DateTime.now(),
    );
  }

  group('HomeProductList Widget Tests', () {
    testWidgets('renders shimmer loading state when future is loading', (
      WidgetTester tester,
    ) async {
      final completer = Completer<List<ProductModel>>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeProductList(
              productsFuture: completer.future,
              searchText: '',
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(Shimmer), findsAtLeastNWidgets(1));

      completer.complete([]);
      await tester.pumpAndSettle();
    });

    testWidgets('renders NoConnectionWidget when socket exception occurs', (
      WidgetTester tester,
    ) async {
      await runZonedGuarded(
        () async {
          final futureWithError = Future<List<ProductModel>>.error(
            Exception('SocketException: Failed host lookup'),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: HomeProductList(
                  productsFuture: futureWithError,
                  searchText: '',
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(find.byType(NoConnectionWidget), findsOneWidget);
        },
        (error, stack) {
        },
      );
    });

    testWidgets('renders empty message when product list is empty', (
      WidgetTester tester,
    ) async {
      final futureEmpty = Future.value(<ProductModel>[]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeProductList(productsFuture: futureEmpty, searchText: ''),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('هیچ محصولی در این دسته‌بندی پیدا نشد.'),
        findsOneWidget,
      );
    });

    testWidgets('renders product items and filters by search text correctly', (
      WidgetTester tester,
    ) async {
      final products = [
        createDummyProduct(id: '1', name: 'گوشی موبایل سامسونگ'),
        createDummyProduct(id: '2', name: 'لپ‌تاپ ایسوس'),
      ];

      final futureProducts = Future.value(products);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HomeProductList(
                productsFuture: futureProducts,
                searchText: 'سامسونگ',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('گوشی موبایل سامسونگ'), findsOneWidget);
      expect(find.text('لپ‌تاپ ایسوس'), findsNothing);
    });
  });
}
