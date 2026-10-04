// test/features/feat_auth/pages/profile_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:my_estahban_city/features/feat_auth/pages/profile_page.dart';
import 'package:my_estahban_city/features/feat_auth/models/user_model.dart';
import 'package:my_estahban_city/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  UserModel createTestUser() {
    return UserModel(
      id: 'user_123',
      email: 'citizen@estahban.city',
      name: 'علی استهبانی',
      userType: 'شهروند',
      phoneNumber: '09171234567',
      address: 'استهبان، خیابان توحید',
      avatar: 'avatar.png',
      created: DateTime(2026, 1, 1),
      updated: DateTime(2026, 4, 1),
    );
  }

  Widget createTestableWidget() {
    return ChangeNotifierProvider<AuthService>.value(
      value: mockAuthService,
      child: MaterialApp(
        routes: {
          '/login': (context) => const Scaffold(body: Text('Login Page')),
        },
        home: const ProfilePage(),
      ),
    );
  }

  group('ProfilePage Widget Tests', () {
    testWidgets(
      'should display user details correctly when user is logged in',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 1920);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        final user = createTestUser();
        when(() => mockAuthService.currentUser).thenReturn(user);

        await tester.pumpWidget(createTestableWidget());

        expect(find.text('پروفایل کاربری'), findsOneWidget);
        expect(find.text('علی استهبانی'), findsOneWidget);
        expect(find.text('citizen@estahban.city'), findsOneWidget);
        expect(find.text('09171234567'), findsOneWidget);
        expect(find.text('استهبان، خیابان توحید'), findsOneWidget);
        expect(find.text('شهروند'), findsOneWidget);
      },
    );

    testWidgets('should trigger logout action when logout button is tapped', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final user = createTestUser();
      when(() => mockAuthService.currentUser).thenReturn(user);
      when(() => mockAuthService.logout()).thenAnswer((_) async => {});

      await tester.pumpWidget(createTestableWidget());

      final logoutButtonFinder = find.text('خروج از حساب کاربری');
      await tester.ensureVisible(logoutButtonFinder);
      await tester.tap(logoutButtonFinder);
      await tester.pumpAndSettle();

      verify(() => mockAuthService.logout()).called(1);
    });
  });
}
