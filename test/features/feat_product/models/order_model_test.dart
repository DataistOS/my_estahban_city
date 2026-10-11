// test/features/feat_product/models/order_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/features/feat_product/models/order_model.dart';

void main() {
  group('OrderModel Tests', () {
    test('fromRecord should correctly parse RecordModel into OrderModel', () {
      final recordData = {
        'id': 'order123456789',
        'data': {
          'user': 'user987654321',
          'items': [
            {'product_id': 'prod1', 'quantity': 2, 'price': 100000.0},
          ],
          'total_amount': 200000.0,
          'shipping_address': {'city': 'Estahban'},
          'status': 'pending',
          'created': '2026-01-01 10:00:00.000Z',
          'updated': '2026-01-01 11:00:00.000Z',
        },
      };

      final record = RecordModel.fromJson(recordData);
      final order = OrderModel.fromRecord(record);

      expect(order.id, 'order123456789');
      expect(order.userId, 'user987654321');
      expect(order.items.length, 1);
      expect(order.totalAmount, 200000.0);
      expect(order.shippingAddress['city'], 'Estahban');
      expect(order.status, 'pending');
      expect(order.created, DateTime.parse('2026-01-01 10:00:00.000Z'));
      expect(order.updated, DateTime.parse('2026-01-01 11:00:00.000Z'));
    });
  });
}
