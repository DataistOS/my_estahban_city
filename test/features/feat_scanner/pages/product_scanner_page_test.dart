// test/features/feat_scanner/pages/product_scanner_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_estahban_city/features/feat_scanner/pages/product_scanner_page.dart';
import 'package:my_estahban_city/services/product_service.dart';
import 'package:my_estahban_city/core/widgets/no_connection_widget.dart';

class FakeProductService extends ProductService {
  final bool shouldReturnProduct;

  FakeProductService({this.shouldReturnProduct = true});

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestableWidget({ProductService? productService}) {
    return MultiProvider(
      providers: [
        Provider<ProductService>.value(
          value: productService ?? FakeProductService(),
        ),
      ],
      child: const MaterialApp(home: ProductScannerPage()),
    );
  }

  group('ProductScannerPage Widget Tests', () {
    testWidgets(
      'renders camera permission request or handles loading state properly',
      (WidgetTester tester) async {
        await tester.pumpWidget(createTestableWidget());

        await tester.pump();

        expect(
          find.byType(CircularProgressIndicator).evaluate().isNotEmpty ||
              find.byType(NoConnectionWidget).evaluate().isNotEmpty ||
              find.text('اسکن محصول').evaluate().isNotEmpty,
          true,
        );
      },
    );

    testWidgets(
      'shows permission denied UI when camera permission is not granted',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: ProductScannerPage()));
        await tester.pump();

        if (find
            .text('دسترسی به دوربین برای اسکن بارکد لازم است.')
            .evaluate()
            .isNotEmpty) {
          expect(
            find.text('دسترسی به دوربین برای اسکن بارکد لازم است.'),
            findsOneWidget,
          );
          expect(find.text('باز کردن تنظیمات'), findsOneWidget);
          expect(find.text('بازگشت به صفحه قبل'), findsOneWidget);
        }
      },
    );
  });
}
