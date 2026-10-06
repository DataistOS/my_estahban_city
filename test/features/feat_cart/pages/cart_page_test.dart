// test/features/feat_cart/pages/cart_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_estahban_city/features/feat_cart/pages/cart_page.dart';

void main() {
  setUpAll(() async {
    dotenv.testLoad(
      fileInput: '''
      SUPPORT_CARD_NUMBER=6104-3379-1234-5678
      SUPPORT_ACCOUNT_NAME=Test Account
      SUPPORT_PHONE_NUMBER=09120000000
    ''',
    );
  });

  testWidgets('CartPage renders correctly and shows title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CartPage()));

    expect(find.text('سبد خرید'), findsOneWidget);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
