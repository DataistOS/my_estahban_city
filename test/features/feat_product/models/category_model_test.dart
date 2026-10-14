// test/features/feat_product/models/category_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';
import 'package:my_estahban_city/features/feat_product/models/category_model.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    pocketBaseInstance = PocketBase('http://127.0.0.1:8090');
  });

  group('CategoryModel Tests', () {
    test(
      'fromRecord should correctly parse RecordModel into CategoryModel',
      () {
        final recordData = {
          'id': 'cat123456789',
          'collectionId': 'pbc_categories',
          'collectionName': 'categories',
          'created': '2026-01-01T10:00:00.000Z',
          'updated': '2026-01-01T11:00:00.000Z',
          'name': 'الکترونیک',
          'icon': 'icon.png',
          'parent_category': 'parent123',
          'data': {
            'name': 'الکترونیک',
            'icon': 'icon.png',
            'parent_category': 'parent123',
          },
        };

        final record = RecordModel.fromJson(recordData);
        final category = CategoryModel.fromRecord(record);

        expect(category.id, 'cat123456789');
        expect(category.name, 'الکترونیک');
        expect(category.icon, contains('icon.png'));
        expect(category.parentCategory, 'parent123');
        expect(category.created, DateTime.parse('2026-01-01T10:00:00.000Z'));
        expect(category.updated, DateTime.parse('2026-01-01T11:00:00.000Z'));
      },
    );

    test('toRecord should correctly convert CategoryModel into Map', () {
      final category = CategoryModel(
        id: 'cat123456789',
        name: 'الکترونیک',
        icon: 'url/icon.png',
        parentCategory: 'parent123',
        created: DateTime.parse('2026-01-01T10:00:00.000Z'),
        updated: DateTime.parse('2026-01-01T11:00:00.000Z'),
      );

      final map = category.toRecord();

      expect(map['name'], 'الکترونیک');
      expect(map['parent_category'], 'parent123');
    });
  });
}
