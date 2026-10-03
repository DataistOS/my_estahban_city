// test/core/widgets/no_connection_widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_estahban_city/core/widgets/no_connection_widget.dart';

void main() {
  group('NoConnectionWidget Tests', () {
    testWidgets(
      'renders default no connection message and wifi icon correctly',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: NoConnectionWidget()));

        expect(find.byIcon(Icons.wifi_off), findsOneWidget);
        expect(
          find.text('لطفاً اتصال اینترنت خود را بررسی کنید'),
          findsOneWidget,
        );
        expect(find.byType(Scaffold), findsOneWidget);
      },
    );

    testWidgets(
      'renders custom child when provided instead of default column',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: NoConnectionWidget(child: Text('Custom Offline View')),
          ),
        );

        expect(find.text('Custom Offline View'), findsOneWidget);
        expect(find.byIcon(Icons.wifi_off), findsNothing);
      },
    );

    testWidgets('applies custom background color correctly', (
      WidgetTester tester,
    ) async {
      const customColor = Colors.red;
      await tester.pumpWidget(
        const MaterialApp(
          home: NoConnectionWidget(backgroundColor: customColor),
        ),
      );

      final scaffoldWidget = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffoldWidget.backgroundColor, customColor);
    });
  });
}
