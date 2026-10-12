// test/features/feat_search/pages/advanced_search_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_estahban_city/features/feat_search/pages/advanced_search_page.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('AdvancedSearchPage Widget Tests', () {
    testWidgets(
      'renders search bar, filter button, and initial state correctly',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: AdvancedSearchPage()));

        expect(find.text('جستجوی پیشرفته'), findsOneWidget);

        expect(find.byType(TextField), findsOneWidget);
        expect(find.byIcon(Icons.filter_list), findsOneWidget);

        expect(find.byType(CircularProgressIndicator), findsWidgets);
      },
    );

    testWidgets('opens filter bottom sheet when filter icon is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AdvancedSearchPage()));

      await tester.pumpAndSettle();

      final filterButtonFinder = find.byIcon(Icons.filter_list);
      expect(filterButtonFinder, findsOneWidget);

      await tester.tap(filterButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('فیلترهای پیشرفته'), findsOneWidget);
      expect(find.text('برند محصول'), findsOneWidget);
      expect(find.text('فقط کالاهای موجود'), findsOneWidget);
      expect(find.text('مرتب‌سازی بر اساس'), findsOneWidget);
      expect(find.text('اعمال فیلترها'), findsOneWidget);
    });
  });
}
