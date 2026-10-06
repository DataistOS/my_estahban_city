// test/features/feat_cart/models/cart_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/features/feat_cart/models/cart_model.dart';

void main() {
  group('CartItemModel Tests', () {
    test('fromJson should parse correctly with valid json', () {
      final json = {'product_id': 'prod123', 'quantity': 3};
      final item = CartItemModel.fromJson(json);

      expect(item.productId, 'prod123');
      expect(item.quantity, 3);
      expect(item.product, isNull);
    });

    test('fromJson should fallback to default values on missing data', () {
      final json = <String, dynamic>{};
      final item = CartItemModel.fromJson(json);

      expect(item.productId, '');
      expect(item.quantity, 1);
    });

    test('toJson should convert item to map correctly', () {
      final item = CartItemModel(productId: 'prod123', quantity: 2);
      final json = item.toJson();

      expect(json['product_id'], 'prod123');
      expect(json['quantity'], 2);
    });
  });

  group('CartModel Tests', () {
    test('fromRecord should parse RecordModel correctly', () {
      final recordData = {
        'user': 'user123',
        'items': [
          {'product_id': 'p1', 'quantity': 2},
        ],
      };

      final record = RecordModel({
        'id': 'cart1',
        'created': '2026-01-01T00:00:00.000Z',
        'updated': '2026-01-01T00:00:00.000Z',
        ...recordData,
      });

      final cart = CartModel.fromRecord(record);

      expect(cart.id, 'cart1');
      expect(cart.userId, 'user123');
      expect(cart.items.length, 1);
      expect(cart.items.first.productId, 'p1');
      expect(cart.items.first.quantity, 2);
    });

    test('toRecord should serialize cart data correctly', () {
      final cart = CartModel(
        id: 'cart1',
        userId: 'user123',
        items: [CartItemModel(productId: 'p1', quantity: 1)],
        created: DateTime.parse('2026-01-01T00:00:00.000Z'),
        updated: DateTime.parse('2026-01-01T00:00:00.000Z'),
      );

      final map = cart.toRecord();

      expect(map['user'], 'user123');
      expect(map['items'], isA<List>());
      expect((map['items'] as List).length, 1);
    });
  });
}
