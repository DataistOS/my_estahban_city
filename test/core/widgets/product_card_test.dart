// test/core/widgets/product_card_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/core/widgets/product_card.dart';
import 'package:my_estahban_city/features/feat_product/models/product_model.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

void main() {
  setUpAll(() {
    pocketBaseInstance = PocketBase('http://127.0.0.1:8090');
  });

  final tProductAvailable = ProductModel(
    id: '1',
    name: 'زعفران سرگل استهبان',
    price: 150000,
    isAvailable: true,
    stock: 10,
    mainImage: 'https://example.com/image.jpg',
    category: 'spices',
    description: 'زعفران درجه یک استهبان',
    galleryImages: [],
    brand: 'برند تستی',
    model: 'مدل تستی',
    weight: 100,
    dimensions: '10x10',
    barcodeId: '123456',
    created: DateTime.parse('2026-01-01 00:00:00'),
    updated: DateTime.parse('2026-01-01 00:00:00'),
  );

  final tProductUnavailable = ProductModel(
    id: '2',
    name: 'انجیر خشک',
    price: 200000,
    isAvailable: false,
    stock: 0,
    mainImage: '',
    category: 'fruits',
    description: 'انجیر خشک اعلا',
    galleryImages: [],
    brand: 'برند تستی',
    model: 'مدل تستی',
    weight: 200,
    dimensions: '15x15',
    barcodeId: '654321',
    created: DateTime.parse('2026-01-01 00:00:00'),
    updated: DateTime.parse('2026-01-01 00:00:00'),
  );

  testWidgets(
    'ProductCard should display product details correctly when available',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ProductCard(product: tProductAvailable)),
        ),
      );

      expect(find.text('زعفران سرگل استهبان'), findsOneWidget);
      expect(find.text('قیمت: 150000 ت'), findsOneWidget);
      expect(find.text('افزودن'), findsOneWidget);
    },
  );

  testWidgets(
    'ProductCard should display unavailable badge and disabled button when out of stock',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ProductCard(product: tProductUnavailable)),
        ),
      );

      expect(find.text('انجیر خشک'), findsOneWidget);
      expect(find.text('وضعیت: ناموجود'), findsOneWidget);
      expect(find.text('ناموجود'), findsWidgets);
    },
  );
}
