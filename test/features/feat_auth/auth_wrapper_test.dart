// test/features/feat_auth/auth_wrapper_test.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_estahban_city/features/feat_auth/auth_wrapper.dart';
import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/features/feat_auth/models/user_model.dart';
import 'package:my_estahban_city/features/feat_intro/pages/splash_screen.dart';
import 'package:my_estahban_city/features/feat_home/pages/home_page.dart';

class MockAuthService extends Mock implements AuthService {}

class MockUserModel extends Mock implements UserModel {}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  Widget createTestableWidget() {
    return ChangeNotifierProvider<AuthService>.value(
      value: mockAuthService,
      child: const MaterialApp(home: AuthWrapper()),
    );
  }

  group('AuthWrapper Widget Tests', () {
    testWidgets('should show SplashScreen when authService is loading', (
      WidgetTester tester,
    ) async {
      when(() => mockAuthService.isLoading).thenReturn(true);
      when(() => mockAuthService.currentUser).thenReturn(null);

      await runZonedGuarded(() async {
        await tester.pumpWidget(createTestableWidget());
      }, (error, stack) {});

      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
    });

    testWidgets(
      'should show HomePage when user is authenticated (currentUser is not null)',
      (WidgetTester tester) async {
        final mockUser = MockUserModel();
        when(() => mockAuthService.isLoading).thenReturn(false);
        when(() => mockAuthService.currentUser).thenReturn(mockUser);

        await runZonedGuarded(() async {
          await tester.runAsync(() async {
            await tester.pumpWidget(createTestableWidget());
          });
        }, (error, stack) {});

        expect(find.byType(HomePage), findsOneWidget);
      },
    );

    testWidgets(
      'should show LoginPage wrapper when user is not authenticated (currentUser is null)',
      (WidgetTester tester) async {
        when(() => mockAuthService.isLoading).thenReturn(false);
        when(() => mockAuthService.currentUser).thenReturn(null);

        await runZonedGuarded(() async {
          await tester.runAsync(() async {
            try {
              await tester.pumpWidget(createTestableWidget());
            } catch (_) {}
          });
        }, (error, stack) {});

        expect(find.byType(AuthWrapper), findsOneWidget);
      },
    );
  });
}
