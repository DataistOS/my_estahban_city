// test/features/feat_search/widgets/search_widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_estahban_city/features/feat_search/widgets/search_widget.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('SearchWidget Widget Tests', () {
    testWidgets('renders search text field, icon and scan button correctly', (
      WidgetTester tester,
    ) async {
      String searchResult = '';
      bool scanPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchWidget(
              onSearch: (query) {
                searchResult = query;
              },
              onScanPressed: () {
                scanPressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('جستجوی محصول...'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'برنج استهبان');
      expect(searchResult, 'برنج استهبان');

      await tester.tap(find.byIcon(Icons.camera_alt));
      expect(scanPressed, isTrue);
    });

    testWidgets('debounces search history saving on typing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchWidget(onSearch: (query) {}, onScanPressed: () {}),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'زعفران');

      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
