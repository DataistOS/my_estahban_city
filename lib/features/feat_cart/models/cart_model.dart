// lib/features/feat_product/cart_model.dart

import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/features/feat_product/models/product_model.dart';

class CartItemModel {
  final String productId;
  int quantity;
  ProductModel? product;

  CartItemModel({
    required this.productId,
    required this.quantity,
    this.product,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['product_id'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'product_id': productId, 'quantity': quantity};
  }
}

class CartModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final DateTime created;
  final DateTime updated;

  CartModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.created,
    required this.updated,
  });

  factory CartModel.fromRecord(RecordModel record) {
    final List<CartItemModel> cartItems = [];
    if (record.data['items'] != null && record.data['items'] is List) {
      for (var item in record.data['items']) {
        cartItems.add(CartItemModel.fromJson(item as Map<String, dynamic>));
      }
    }

    return CartModel(
      id: record.id,
      userId: record.data['user'],
      items: cartItems,
      created: DateTime.parse(record.get<String>('created')),
      updated: DateTime.parse(record.get<String>('updated')),
    );
  }

  Map<String, dynamic> toRecord() {
    return {
      'user': userId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
