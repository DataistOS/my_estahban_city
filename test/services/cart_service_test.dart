// test/services/cart_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/services/cart_service.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

void main() {
  setUpAll(() {
    pocketBaseInstance = PocketBase('http://127.0.0.1:8090');
  });

  late CartService cartService;

  setUp(() {
    cartService = CartService();
  });

  group('CartService Tests (Unauthenticated state)', () {
    test('getCart should return null when user is not authenticated', () async {
      final cart = await cartService.getCart();
      expect(cart, isNull);
    });

    test(
      'getCartWithProducts should return null when user is not authenticated',
      () async {
        final cartWithProducts = await cartService.getCartWithProducts();
        expect(cartWithProducts, isNull);
      },
    );

    test(
      'getOrders should return empty list when user is not authenticated',
      () async {
        final orders = await cartService.getOrders();
        expect(orders, isEmpty);
      },
    );
  });
}
