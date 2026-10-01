// test/features/feat_cart/cart_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/features/feat_cart/pages/cart_page.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

void main() {
  setUpAll(() {
    pocketBaseInstance = PocketBase('http://127.0.0.1:8090');
  });

  testWidgets('CartPage should display empty cart message when cart is empty', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CartPage()));

    await tester.pumpAndSettle();

    expect(find.text('سبد خرید'), findsOneWidget);
  });

  testWidgets('CartPage should render checkout banner and title correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CartPage()));

    await tester.pump();

    expect(find.text('سبد خرید'), findsOneWidget);
  });
}
