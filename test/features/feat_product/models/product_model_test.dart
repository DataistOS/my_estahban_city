// test/features/feat_product/models/product_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_estahban_city/features/feat_product/models/product_model.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    pocketBaseInstance = PocketBase('http://127.0.0.1:8090');
  });

  group('ProductModel Tests', () {
    test(
      'fromRecord should correctly parse a PocketBase RecordModel into ProductModel',
      () {
        final Map<String, dynamic> rawData = {
          'id': 'prod123',
          'collectionId': 'products_col',
          'collectionName': 'products',
          'created': '2026-01-01T10:00:00.000Z',
          'updated': '2026-01-01T12:00:00.000Z',
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

        final record = RecordModel.fromJson(rawData);
        final product = ProductModel.fromRecord(record);

        expect(product.id, 'prod123');
        expect(product.name, 'گوشی موبایل');
        expect(product.price, 15000000.0);
        expect(product.brand, 'سامسونگ');
      },
    );
  });
}
