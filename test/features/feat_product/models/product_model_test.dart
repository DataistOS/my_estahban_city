// test/features/feat_product/models/product_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/features/feat_product/models/product_model.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

void main() {
  setUpAll(() {
    pocketBaseInstance = PocketBase('http://127.0.0.1:8090');
  });

  group('ProductModel Tests', () {
    test(
      'fromRecord should correctly parse a PocketBase RecordModel into ProductModel',
      () {
        final Map<String, dynamic> recordData = {
          'id': 'prod123',
          'collectionId': 'products_col',
          'collectionName': 'products',
          'created': '2026-01-01 10:00:00.000Z',
          'updated': '2026-01-01 12:00:00.000Z',
          'data': {
            'name': 'گوشی موبایل',
            'description': 'توضیحات تست گوشی موبایل',
            'price': 15000000.0,
            'stock': 10.0,
            'category': 'digital',
            'main_image': 'main.jpg',
            'gallery_images': ['img1.jpg', 'img2.jpg'],
            'brand': 'سامسونگ',
            'model': 'Galaxy S24',
            'weight': 160.0,
            'dimensions': '15x7 cm',
            'is_available': true,
            'barcode_id': '123456789',
          },
        };

        final record = RecordModel.fromJson(recordData);
        final product = ProductModel.fromRecord(record);

        expect(product.id, 'prod123');
        expect(product.name, 'گوشی موبایل');
        expect(product.description, 'توضیحات تست گوشی موبایل');
        expect(product.price, 15000000.0);
        expect(product.stock, 10.0);
        expect(product.category, 'digital');
        expect(product.brand, 'سامسونگ');
        expect(product.model, 'Galaxy S24');
        expect(product.isAvailable, true);
        expect(product.barcodeId, '123456789');
        expect(product.mainImage, contains('main.jpg'));
        expect(product.galleryImages.length, 2);
        expect(product.created, isA<DateTime>());
      },
    );

    test('toRecord should correctly convert ProductModel to Map', () {
      final product = ProductModel(
        id: 'prod123',
        name: 'گوشی موبایل',
        description: 'توضیحات',
        price: 15000000.0,
        stock: 5.0,
        category: 'digital',
        mainImage: 'url/main.jpg',
        galleryImages: [],
        brand: 'شیائومی',
        model: 'Note 13',
        weight: 180.0,
        dimensions: '16x8 cm',
        isAvailable: true,
        barcodeId: '987654321',
        created: DateTime(2026, 1, 1),
        updated: DateTime(2026, 1, 1),
      );

      final map = product.toRecord();

      expect(map['name'], 'گوشی موبایل');
      expect(map['price'], 15000000.0);
      expect(map['stock'], 5.0);
      expect(map['category'], 'digital');
      expect(map['brand'], 'شیائومی');
      expect(map['model'], 'Note 13');
      expect(map['is_available'], true);
    });
  });
}
