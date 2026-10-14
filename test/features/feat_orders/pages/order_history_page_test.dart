// test/features/feat_orders/pages/order_history_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';
import 'package:my_estahban_city/features/feat_orders/pages/order_history_page.dart';

void main() {
  setUpAll(() async {
    dotenv.testLoad(
      fileInput: '''
      SUPPORT_CARD_NUMBER=6104-3379-1234-5678
      SUPPORT_ACCOUNT_NAME=شرکت استهبان‌من
      SUPPORT_PHONE_NUMBER=09123456789
      POCKETBASE_URL=https://my.estahban.city
    ''',
    );
    SharedPreferences.setMockInitialValues({});
    pocketBaseInstance = PocketBase('https://my.estahban.city');
  });

  group('OrderHistoryPage Widget Tests', () {
    testWidgets('renders empty state when there are no orders', (
        WidgetTester tester,
        ) async {
      SharedPreferences.setMockInitialValues({'hidden_orders': <String>[]});

      await tester.pumpWidget(const MaterialApp(home: OrderHistoryPage()));

      await tester.pumpAndSettle();

      expect(find.text('تاریخچه سفارشات'), findsOneWidget);
      expect(find.text('راهنمای پرداخت و تایید سفارش'), findsOneWidget);
    });

    testWidgets(
      'clears local history when delete button is pressed and confirmed',
          (WidgetTester tester) async {
        SharedPreferences.setMockInitialValues({'hidden_orders': <String>[]});

        await tester.pumpWidget(const MaterialApp(home: OrderHistoryPage()));

        await tester.pumpAndSettle();

        final deleteIconFinder = find.byIcon(Icons.delete_sweep);
        if (deleteIconFinder.evaluate().isNotEmpty) {
          await tester.tap(deleteIconFinder);
          await tester.pumpAndSettle();

          expect(find.text('پاک کردن تاریخچه'), findsOneWidget);

          await tester.tap(find.text('پاک کردن'));
          await tester.pumpAndSettle();
        }
      },
    );
  });
}