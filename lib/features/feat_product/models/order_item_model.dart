import 'package:pocketbase/pocketbase.dart';

class OrderItemModel {
  final String id;
  final String order;
  final String product;
  final int quantity;
  final double priceAtPurchase;
  final DateTime created;
  final DateTime updated;

  OrderItemModel({
    required this.id,
    required this.order,
    required this.product,
    required this.quantity,
    required this.priceAtPurchase,
    required this.created,
    required this.updated,
  });

  factory OrderItemModel.fromRecord(RecordModel record) {
    return OrderItemModel(
      id: record.id,
      order: record.data['order'],
      product: record.data['product'],
      quantity: record.data['quantity']?.toInt() ?? 0,
      priceAtPurchase: record.data['price_at_purchase']?.toDouble() ?? 0.0,
      created: DateTime.parse(record.created),
      updated: DateTime.parse(record.updated),
    );
  }

  Map<String, dynamic> toRecord() {
    return {
      'order': order,
      'product': product,
      'quantity': quantity,
      'price_at_purchase': priceAtPurchase,
    };
  }
}
