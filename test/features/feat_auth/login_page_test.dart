// test/features/feat_auth/login_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/features/feat_auth/pages/login_page.dart';
import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/features/feat_auth/models/user_model.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

class FakeAuthService extends ChangeNotifier implements AuthService {
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get errorMessage => _errorMessage;

  @override
  UserModel? get currentUser => _currentUser;

  @override
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  Future<void> login(String nationalCode, String password) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 50));
    _isLoading = false;

    if (nationalCode == '1234567890' && password == 'password123') {
    } else {
      _errorMessage = 'اطلاعات ورود نامعتبر است';
    }
    notifyListeners();
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() {
    pocketBaseInstance = PocketBase('http://127.0.0.1:8090');
  });

  late FakeAuthService fakeAuthService;

  setUp(() {
    fakeAuthService = FakeAuthService();
  });

  Widget createLoginPage() {
    return ChangeNotifierProvider<AuthService>.value(
      value: fakeAuthService,
      child: const MaterialApp(home: LoginPage()),
    );
  }

  testWidgets(
    'LoginPage should display form fields, title, and buttons correctly',
    (WidgetTester tester) async {
      await tester.pumpWidget(createLoginPage());
      await tester.pumpAndSettle();

      expect(find.text('ورود به حساب کاربری'), findsOneWidget);
      expect(find.text('کد ملی'), findsOneWidget);
      expect(find.text('رمز عبور'), findsOneWidget);
      expect(find.text('ورود'), findsOneWidget);
      expect(
        find.text('هنوز حساب کاربری ندارید؟ ثبت‌نام کنید.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'LoginPage should show validation errors when fields are empty and submit is clicked',
    (WidgetTester tester) async {
      await tester.pumpWidget(createLoginPage());
      await tester.pumpAndSettle();

      await tester.tap(find.text('ورود'));
      await tester.pump();

      expect(find.text('لطفا کد ملی خود را وارد کنید'), findsOneWidget);
      expect(find.text('لطفا رمز عبور خود را وارد کنید'), findsOneWidget);
    },
  );

  testWidgets(
    'LoginPage should show validation error when national code length is invalid',
    (WidgetTester tester) async {
      await tester.pumpWidget(createLoginPage());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), '12345');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');

      await tester.tap(find.text('ورود'));
      await tester.pump();

      expect(find.text('کد ملی باید ۱۰ رقم باشد'), findsOneWidget);
    },
  );
}
