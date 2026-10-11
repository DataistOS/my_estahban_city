// test/features/feat_product/models/order_item_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/features/feat_product/models/order_item_model.dart';

void main() {
  group('OrderItemModel Tests', () {
    test(
      'fromRecord should correctly parse RecordModel into OrderItemModel',
      () {
        final recordData = {
          'id': 'item123456789',
          'data': {
            'order': 'order987654321',
            'product': 'prod111222333',
            'quantity': 2,
            'price_at_purchase': 150000.0,
            'created': '2026-01-01 10:00:00.000Z',
            'updated': '2026-01-01 11:00:00.000Z',
          },
        };

        final record = RecordModel.fromJson(recordData);
        final orderItem = OrderItemModel.fromRecord(record);

        expect(orderItem.id, 'item123456789');
        expect(orderItem.order, 'order987654321');
        expect(orderItem.product, 'prod111222333');
        expect(orderItem.quantity, 2);
        expect(orderItem.priceAtPurchase, 150000.0);
        expect(orderItem.created, DateTime.parse('2026-01-01 10:00:00.000Z'));
        expect(orderItem.updated, DateTime.parse('2026-01-01 11:00:00.000Z'));
      },
    );

    test('toRecord should correctly convert OrderItemModel into Map', () {
      final orderItem = OrderItemModel(
        id: 'item123456789',
        order: 'order987654321',
        product: 'prod111222333',
        quantity: 3,
        priceAtPurchase: 200000.0,
        created: DateTime.parse('2026-01-01 10:00:00.000Z'),
        updated: DateTime.parse('2026-01-01 11:00:00.000Z'),
      );

      final map = orderItem.toRecord();

      expect(map['order'], 'order987654321');
      expect(map['product'], 'prod111222333');
      expect(map['quantity'], 3);
      expect(map['price_at_purchase'], 200000.0);
    });
  });
}
