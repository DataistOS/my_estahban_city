// test/core/widgets/add_to_cart_button_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/core/widgets/add_to_cart_button.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

class MockPocketBase extends Mock implements PocketBase {}

class MockAuthStore extends Mock implements AuthStore {}

class MockRecordService extends Mock implements RecordService {}

void main() {
  setUp(() {
    final mockPb = MockPocketBase();
    final mockAuthStore = MockAuthStore();
    when(() => mockPb.authStore).thenReturn(mockAuthStore);
    when(() => mockAuthStore.record).thenReturn(null);
    pocketBaseInstance = mockPb;
  });

  Widget createTestableWidget() {
    return const MaterialApp(
      home: Scaffold(body: AddToCartButton(productId: 'product_123')),
    );
  }

  group('AddToCartButton Widget Tests', () {
    testWidgets('renders add to cart button and elements correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());

      expect(find.text('افزودن'), findsOneWidget);
      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
    });

    testWidgets('tap on button triggers action without crashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());

      await tester.tap(find.text('افزودن'));
      await tester.pump();

      expect(find.text('افزودن'), findsOneWidget);
    });
  });
}
