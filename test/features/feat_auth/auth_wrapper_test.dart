// test/features/feat_auth/auth_wrapper_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:my_estahban_city/features/feat_auth/auth_wrapper.dart';
import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/features/feat_auth/models/user_model.dart';
import 'package:my_estahban_city/features/feat_intro/pages/splash_screen.dart';
import 'package:my_estahban_city/features/feat_auth/pages/login_page.dart';
import 'package:my_estahban_city/features/feat_home/pages/home_page.dart';

class MockAuthService extends Mock implements AuthService {}

class MockUserModel extends Mock implements UserModel {}

void main() {
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

      await tester.pumpWidget(createTestableWidget());

      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
      expect(find.byType(HomePage), findsNothing);
    });

    testWidgets(
      'should show HomePage when user is authenticated (currentUser is not null)',
      (WidgetTester tester) async {
        final mockUser = MockUserModel();
        when(() => mockAuthService.isLoading).thenReturn(false);
        when(() => mockAuthService.currentUser).thenReturn(mockUser);

        await tester.pumpWidget(createTestableWidget());

        expect(find.byType(HomePage), findsOneWidget);
        expect(find.byType(LoginPage), findsNothing);
      },
    );

    testWidgets(
      'should show LoginPage when user is not authenticated (currentUser is null)',
      (WidgetTester tester) async {
        when(() => mockAuthService.isLoading).thenReturn(false);
        when(() => mockAuthService.currentUser).thenReturn(null);

        await tester.pumpWidget(createTestableWidget());

        expect(find.byType(LoginPage), findsOneWidget);
        expect(find.byType(HomePage), findsNothing);
      },
    );
  });
}
