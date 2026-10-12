// test/features/feat_product/pages/request_product_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_estahban_city/features/feat_product/pages/request_product_page.dart';
import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/features/feat_auth/models/user_model.dart';

class FakeAuthService extends ChangeNotifier implements AuthService {
  UserModel? _currentUser;

  FakeAuthService({UserModel? initialUser}) : _currentUser = initialUser;

  @override
  UserModel? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  void setCurrentUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestableWidget({AuthService? authService}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(
          value: authService ?? FakeAuthService(),
        ),
      ],
      child: const MaterialApp(home: RequestProductPage()),
    );
  }

  group('RequestProductPage Widget Tests', () {
    testWidgets('renders title, description and submit button correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());

      expect(find.text('درخواست موجود کردن محصول'), findsOneWidget);
      expect(
        find.textContaining('اگر محصول مورد نظر شما در فروشگاه موجود نیست'),
        findsOneWidget,
      );
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('ارسال درخواست'), findsOneWidget);
    });

    testWidgets('shows snackbar when submitting empty request text', (
      WidgetTester tester,
    ) async {
      final authService = FakeAuthService(
        initialUser: UserModel(
          id: 'user_123',
          email: 'test@example.com',
          name: 'تست کاربر',
          avatar: '',
          created: DateTime.now(),
          updated: DateTime.now(),
        ),
      );

      await tester.pumpWidget(createTestableWidget(authService: authService));

      await tester.tap(find.text('ارسال درخواست'));
      await tester.pump();

      expect(find.text('لطفاً متن درخواست خود را وارد کنید.'), findsOneWidget);
    });

    testWidgets('shows login warning snackbar when user is not authenticated', (
      WidgetTester tester,
    ) async {
      final authService = FakeAuthService(initialUser: null);

      await tester.pumpWidget(createTestableWidget(authService: authService));

      await tester.enterText(find.byType(TextField), 'گوشی موبایل تستی');
      await tester.tap(find.text('ارسال درخواست'));
      await tester.pump();

      expect(
        find.text('برای ثبت درخواست، ابتدا وارد حساب کاربری خود شوید.'),
        findsOneWidget,
      );
    });
  });
}
