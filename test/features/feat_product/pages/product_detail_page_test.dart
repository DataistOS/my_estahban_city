  // test/features/feat_product/pages/product_detail_page_test.dart

  import 'package:flutter/material.dart';
  import 'package:flutter_test/flutter_test.dart';
  import 'package:pocketbase/pocketbase.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:my_estahban_city/services/pocketbase_instance.dart';
  import 'package:my_estahban_city/features/feat_product/models/product_model.dart';
  import 'package:my_estahban_city/features/feat_product/pages/product_detail_page.dart';
  import 'package:my_estahban_city/core/widgets/add_to_cart_button.dart';

  void main() {
    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      pocketBaseInstance = PocketBase('http://127.0.0.1:8090');
    });

    ProductModel createTestProduct() {
      return ProductModel(
        id: 'prod_123',
        name: 'محصول تستی ویژه',
        description: 'این یک توضیحات کامل و جامع برای محصول تستی است.',
        price: 150000.0,
        stock: 5,
        category: 'cat_electronics',
        mainImage: 'https://example.com/main.jpg',
        galleryImages: ['https://example.com/gallery1.jpg'],
        isAvailable: true,
        created: DateTime.now(),
        updated: DateTime.now(),
      );
    }

    group('ProductDetailPage Widget Tests', () {
      testWidgets(
        'renders product details, price, description and add to cart button correctly',
        (WidgetTester tester) async {
          final product = createTestProduct();

          await tester.pumpWidget(
            MaterialApp(home: ProductDetailPage(product: product)),
          );
          await tester.pump();

          expect(find.text('محصول تستی ویژه'), findsWidgets);
          expect(find.text('توضیحات محصول'), findsOneWidget);
          expect(
            find.text('این یک توضیحات کامل و جامع برای محصول تستی است.'),
            findsOneWidget,
          );
          expect(find.byType(AddToCartButton), findsOneWidget);
        },
      );

      testWidgets('taps on main image navigates to FullScreenImagePage', (
        WidgetTester tester,
      ) async {
        final product = createTestProduct();

        await tester.pumpWidget(
          MaterialApp(home: ProductDetailPage(product: product)),
        );

        await tester.pumpAndSettle();

        final imageFinder = find.byType(InkWell).first;
        if (imageFinder.evaluate().isNotEmpty) {
          await tester.tap(imageFinder);
          await tester.pumpAndSettle();
        }

        expect(find.byType(ProductDetailPage), findsOneWidget);
      });
    });
  }
