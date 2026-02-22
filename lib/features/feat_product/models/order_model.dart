// lib/features/feat_product/order_model.dart

import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/features/feat_cart/models/cart_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;
  final Map<String, dynamic> shippingAddress;
  final String status;
  final DateTime created;
  final DateTime updated;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.status,
    required this.created,
    required this.updated,
  });

  factory OrderModel.fromRecord(RecordModel record) {
    final List<CartItemModel> orderItems = [];
    if (record.data['items'] != null && record.data['items'] is List) {
      for (var item in record.data['items']) {
        orderItems.add(CartItemModel.fromJson(item as Map<String, dynamic>));
      }
    }
    return OrderModel(
      id: record.id,
      userId: record.data['user'],
      items: orderItems,
      totalAmount: record.data['total_amount']?.toDouble() ?? 0.0,
      shippingAddress: record.data['shipping_address'] ?? {},
      status: record.data['status'] ?? 'unknown',
      // Corrected to use get<String> for deprecated fields
      created: DateTime.parse(record.get<String>('created')),
      updated: DateTime.parse(record.get<String>('updated')),
    );
  }
}
