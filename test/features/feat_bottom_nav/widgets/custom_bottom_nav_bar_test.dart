// test/features/feat_bottom_nav/widgets/custom_bottom_nav_bar_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

import 'package:my_estahban_city/features/feat_bottom_nav/widgets/custom_bottom_nav_bar.dart';
import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/features/feat_auth/models/user_model.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  Widget createTestableWidget({
    required Function(String? categoryId, String title) onCategorySelected,
  }) {
    return MaterialApp(
      routes: {
        '/login': (context) => const Scaffold(body: Text('Login Screen Mock')),
      },
      home: Scaffold(
        bottomNavigationBar: ChangeNotifierProvider<AuthService>.value(
          value: mockAuthService,
          child: CustomBottomNavBar(onCategorySelected: onCategorySelected),
        ),
      ),
    );
  }

  group('CustomBottomNavBar Widget Tests', () {
    testWidgets('renders categories and profile icons correctly', (
      WidgetTester tester,
    ) async {
      when(() => mockAuthService.currentUser).thenReturn(null);

      await tester.pumpWidget(
        createTestableWidget(onCategorySelected: (id, title) {}),
      );

      expect(find.byIcon(Icons.category_outlined), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('opens categories bottom sheet and selects showcase category', (
      WidgetTester tester,
    ) async {
      String? selectedId;
      String? selectedTitle;

      await tester.pumpWidget(
        createTestableWidget(
          onCategorySelected: (id, title) {
            selectedId = id;
            selectedTitle = title;
          },
        ),
      );

      await tester.tap(find.byIcon(Icons.category_outlined));
      await tester.pumpAndSettle();

      expect(find.text('انتخاب دسته‌بندی محصولات'), findsOneWidget);
      expect(find.text('ویترین'), findsOneWidget);

      await tester.tap(find.text('ویترین'));
      await tester.pumpAndSettle();

      expect(selectedId, CustomBottomNavBar.showcaseId);
      expect(selectedTitle, 'ویترین');
    });

    testWidgets(
      'navigates to login when profile icon tapped and user is not logged in',
      (WidgetTester tester) async {
        when(() => mockAuthService.currentUser).thenReturn(null);

        await tester.pumpWidget(
          createTestableWidget(onCategorySelected: (id, title) {}),
        );

        await tester.tap(find.byIcon(Icons.person_outline));
        await tester.pumpAndSettle();

        expect(find.text('Login Screen Mock'), findsOneWidget);
      },
    );

    testWidgets('navigates to profile page when user is logged in', (
      WidgetTester tester,
    ) async {
      final mockUser = UserModel(
        id: '1',
        email: 'test@example.com',
        name: 'کاربر تستی',
        avatar: '',
        created: DateTime.now(),
        updated: DateTime.now(),
      );

      when(() => mockAuthService.currentUser).thenReturn(mockUser);

      await tester.pumpWidget(
        createTestableWidget(onCategorySelected: (id, title) {}),
      );

      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();

      expect(find.byType(CustomBottomNavBar), findsNothing);
    });
  });
}
