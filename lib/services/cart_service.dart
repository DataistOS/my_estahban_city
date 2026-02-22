// lib/services/cart_service.dart

import 'package:pocketbase/pocketbase.dart';

import 'package:my_estahban_city/services/pocketbase_instance.dart';
import 'package:my_estahban_city/features/feat_cart/models/cart_model.dart';
import 'package:my_estahban_city/features/feat_auth/models/user_model.dart';
import 'package:my_estahban_city/features/feat_product/models/product_model.dart';
import 'package:my_estahban_city/features/feat_product/models/order_model.dart';

class CartService {
  final PocketBase pb = pocketBaseInstance;

  Future<CartModel?> getCart() async {
    final currentUser = pb.authStore.record != null
        ? UserModel.fromRecord(pb.authStore.record!)
        : null;
    if (currentUser == null) return null;

    try {
      final record = await pb
          .collection('cart')
          .getFirstListItem('user = "${currentUser.id}"');
      return CartModel.fromRecord(record);
    } catch (e) {
      if (e is ClientException && e.response['code'] == 404) {
        final newRecord = await pb
            .collection('cart')
            .create(body: {'user': currentUser.id, 'items': []});
        return CartModel.fromRecord(newRecord);
      }
      rethrow;
    }
  }

  Future<CartModel?> getCartWithProducts() async {
    final currentUser = pb.authStore.record != null
        ? UserModel.fromRecord(pb.authStore.record!)
        : null;
    if (currentUser == null) return null;

    try {
      final record = await pb
          .collection('cart')
          .getFirstListItem(
            'user = "${currentUser.id}"',
            expand: 'items.product',
          );

      final cartItems = (record.data['items'] as List?)
          ?.map(
            (item) => CartItemModel.fromJson(item as Map<String, dynamic>)
              ..product = ProductModel.fromRecord(item['expand']['product']),
          )
          .toList();

      return CartModel(
        id: record.id,
        userId: record.data['user'],
        items: cartItems ?? [],
        created: DateTime.parse(record.get<String>('created')),
        updated: DateTime.parse(record.get<String>('updated')),
      );
    } catch (e) {
      if (e is ClientException && e.response['code'] == 404) {
        return null;
      }
      rethrow;
    }
  }

  Future<void> addItemToCart(String productId, {int quantity = 1}) async {
    final currentUser = pb.authStore.record != null
        ? UserModel.fromRecord(pb.authStore.record!)
        : null;

    if (currentUser == null) return;

    try {
      final cartRecord = await pb
          .collection('cart')
          .getFirstListItem('user = "${currentUser.id}"');

      final currentCart = CartModel.fromRecord(cartRecord);
      final itemIndex = currentCart.items.indexWhere(
        (item) => item.productId == productId,
      );

      if (itemIndex != -1) {
        currentCart.items[itemIndex].quantity += quantity;
      } else {
        currentCart.items.add(
          CartItemModel(productId: productId, quantity: quantity),
        );
      }

      await pb
          .collection('cart')
          .update(
            cartRecord.id,
            body: {'items': currentCart.items.map((e) => e.toJson()).toList()},
          );
    } on ClientException catch (e) {
      if (e.response['code'] == 404) {
        await pb
            .collection('cart')
            .create(
              body: {
                'user': currentUser.id,
                'items': [
                  CartItemModel(
                    productId: productId,
                    quantity: quantity,
                  ).toJson(),
                ],
              },
            );
      }
      rethrow;
    }
  }

  Future<void> removeItemFromCart(String productId) async {
    final currentUser = pb.authStore.record != null
        ? UserModel.fromRecord(pb.authStore.record!)
        : null;
    if (currentUser == null) return;

    final cartRecord = await pb
        .collection('cart')
        .getFirstListItem('user = "${currentUser.id}"');

    final currentCart = CartModel.fromRecord(cartRecord);
    currentCart.items.removeWhere((item) => item.productId == productId);

    await pb
        .collection('cart')
        .update(
          cartRecord.id,
          body: {'items': currentCart.items.map((e) => e.toJson()).toList()},
        );
  }

  Future<void> updateItemQuantity(String productId, int newQuantity) async {
    final currentUser = pb.authStore.record != null
        ? UserModel.fromRecord(pb.authStore.record!)
        : null;
    if (currentUser == null) return;

    final cartRecord = await pb
        .collection('cart')
        .getFirstListItem('user = "${currentUser.id}"');

    final currentCart = CartModel.fromRecord(cartRecord);
    final itemIndex = currentCart.items.indexWhere(
      (item) => item.productId == productId,
    );

    if (itemIndex != -1) {
      if (newQuantity <= 0) {
        currentCart.items.removeAt(itemIndex);
      } else {
        currentCart.items[itemIndex].quantity = newQuantity;
      }
      await pb
          .collection('cart')
          .update(
            cartRecord.id,
            body: {'items': currentCart.items.map((e) => e.toJson()).toList()},
          );
    }
  }

  Future<void> clearCart() async {
    final currentUser = pb.authStore.record != null
        ? UserModel.fromRecord(pb.authStore.record!)
        : null;
    if (currentUser == null) return;

    final cartRecord = await pb
        .collection('cart')
        .getFirstListItem('user = "${currentUser.id}"');

    await pb.collection('cart').update(cartRecord.id, body: {'items': []});
  }

  Future<void> checkout(
    double totalAmount,
    Map<String, dynamic> shippingAddress,
  ) async {
    final currentUser = pb.authStore.record != null
        ? UserModel.fromRecord(pb.authStore.record!)
        : null;
    if (currentUser == null) return;

    final cartRecord = await pb
        .collection('cart')
        .getFirstListItem('user = "${currentUser.id}"');
    final currentCart = CartModel.fromRecord(cartRecord);

    await pb
        .collection('orders')
        .create(
          body: {
            'user': currentUser.id,
            'items': currentCart.items.map((e) => e.toJson()).toList(),
            'total_amount': totalAmount,
            'shipping_address': shippingAddress,
            'status': 'pending',
          },
        );

    await clearCart();
  }

  Future<List<OrderModel>> getOrders() async {
    final currentUser = pb.authStore.record != null
        ? UserModel.fromRecord(pb.authStore.record!)
        : null;
    if (currentUser == null) return [];

    final records = await pb
        .collection('orders')
        .getFullList(filter: 'user = "${currentUser.id}"', sort: '-created');

    return records.map((record) => OrderModel.fromRecord(record)).toList();
  }
}
