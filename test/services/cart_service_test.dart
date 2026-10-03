// test/services/cart_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';

import 'package:my_estahban_city/services/cart_service.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

class MockPocketBase extends Mock implements PocketBase {}

class MockAuthStore extends Mock implements AuthStore {}

class MockRecordService extends Mock implements RecordService {}

class MockRecordModel extends Mock implements RecordModel {}

void main() {
  late CartService cartService;
  late MockPocketBase mockPb;
  late MockAuthStore mockAuthStore;

  setUp(() {
    mockPb = MockPocketBase();
    mockAuthStore = MockAuthStore();

    pocketBaseInstance = mockPb;

    when(() => mockPb.authStore).thenReturn(mockAuthStore);

    cartService = CartService();
  });

  group('CartService Unauthenticated Tests', () {
    test('getCart should return null when user is not authenticated', () async {
      when(() => mockAuthStore.record).thenReturn(null);

      final cart = await cartService.getCart();
      expect(cart, isNull);
    });

    test(
      'getCartWithProducts should return null when user is not authenticated',
      () async {
        when(() => mockAuthStore.record).thenReturn(null);

        final cartWithProducts = await cartService.getCartWithProducts();
        expect(cartWithProducts, isNull);
      },
    );

    test(
      'getOrders should return empty list when user is not authenticated',
      () async {
        when(() => mockAuthStore.record).thenReturn(null);

        final orders = await cartService.getOrders();
        expect(orders, isEmpty);
      },
    );
  });
}
