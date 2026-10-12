// test/features/feat_home/widgets/app_drawer_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:my_estahban_city/features/feat_home/widgets/app_drawer.dart';
import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/features/feat_auth/models/user_model.dart';

class FakeAuthService extends ChangeNotifier implements AuthService {
  @override
  UserModel? currentUser;

  @override
  bool get isAuthenticated => currentUser != null;

  @override
  bool get isLoading => false;

  String? _errorMessage;

  @override
  String? get errorMessage => _errorMessage;

  @override
  Future<void> login(String email, String password) async {}

  @override
  Future<void> register(Map<String, dynamic> data) async {}

  @override
  Future<void> logout() async {
    currentUser = null;
    notifyListeners();
  }

  @override
  void clearError() {
    _errorMessage = null;
  }
}

void main() {
  setUpAll(() async {
    dotenv.testLoad(
      fileInput: '''
      SUPPORT_ADDRESS=استهبان، خیابان انقلاب
      SUPPORT_PHONE_NUMBER=07133333333
      APP_VERSION=v0.8.4
    ''',
    );
  });

  late FakeAuthService fakeAuthService;

  setUp(() {
    fakeAuthService = FakeAuthService();
  });

  Widget createAppDrawerWidget() {
    return ChangeNotifierProvider<AuthService>.value(
      value: fakeAuthService,
      child: MaterialApp(
        home: Scaffold(
          drawer: AppDrawer(),
          body: Builder(
            builder: (context) {
              return Center(
                child: ElevatedButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  child: const Text('Open Drawer'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  group('AppDrawer Widget Tests', () {
    testWidgets(
      'renders all drawer items and environment variables correctly',
      (WidgetTester tester) async {
        fakeAuthService.currentUser = null;

        await tester.pumpWidget(createAppDrawerWidget());

        await tester.tap(find.text('Open Drawer'));
        await tester.pumpAndSettle();

        expect(find.text('استهبان‌من'), findsOneWidget);
        expect(find.text('همراه هوشمند شهروندان'), findsOneWidget);

        expect(find.text('پروفایل ‌من'), findsOneWidget);
        expect(find.text('تاریخچه خرید'), findsOneWidget);
        expect(find.text('درخواست محصول'), findsOneWidget);
        expect(find.text('درباره ما'), findsOneWidget);

        expect(find.text('استهبان، خیابان انقلاب'), findsOneWidget);
        expect(find.text('تلفن: 07133333333'), findsOneWidget);
        expect(find.text('v0.8.4'), findsOneWidget);
      },
    );

    testWidgets('navigates to login when unauthenticated user taps profile', (
      WidgetTester tester,
    ) async {
      fakeAuthService.currentUser = null;

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/login': (context) => const Scaffold(body: Text('Login Page')),
          },
          home: Scaffold(
            drawer: AppDrawer(),
            body: Builder(
              builder: (context) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    child: const Text('Open Drawer'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Drawer'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('پروفایل ‌من'));
      await tester.pumpAndSettle();

      expect(find.text('Login Page'), findsOneWidget);
    });
  });
}
