// test/features/feat_home/pages/quick_tools_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:my_estahban_city/features/feat_home/pages/quick_tools_page.dart';
import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/features/feat_auth/models/user_model.dart';

class FakeAuthService extends ChangeNotifier implements AuthService {
  @override
  UserModel? currentUser;

  @override
  bool get isAuthenticated => currentUser != null;

  @override
  bool get isLoading => false;

  @override
  String? errorMessage;

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
    errorMessage = null;
  }
}

void main() {
  late FakeAuthService fakeAuthService;

  setUp(() {
    fakeAuthService = FakeAuthService();
  });

  Widget createQuickToolsPage() {
    return ChangeNotifierProvider<AuthService>.value(
      value: fakeAuthService,
      child: const MaterialApp(home: QuickToolsPage()),
    );
  }

  group('QuickToolsPage Widget Tests', () {
    testWidgets('renders all quick tools items correctly', (
      WidgetTester tester,
    ) async {
      fakeAuthService.currentUser = null;

      await tester.pumpWidget(createQuickToolsPage());
      await tester.pump();

      expect(find.text('امکانات سریع و ابزارها'), findsOneWidget);

      expect(find.text('اسکن بارکد محصول'), findsOneWidget);
      expect(find.text('کلینیک و خدمات تعمیراتی'), findsOneWidget);
      expect(find.text('برندها و مدل‌ها'), findsOneWidget);
      expect(find.text('جستجوی پیشرفته'), findsOneWidget);
    });

    testWidgets('shows VIP snackbar when free user clicks on repair clinic', (
      WidgetTester tester,
    ) async {
      fakeAuthService.currentUser = UserModel(
        id: 'user1',
        email: 'test@example.com',
        name: 'Test User',
        avatar: '',
        tier: 'free',
        created: DateTime.now(),
        updated: DateTime.now(),
      );

      await tester.pumpWidget(createQuickToolsPage());
      await tester.pump();

      await tester.tap(find.text('کلینیک و خدمات تعمیراتی'));
      await tester.pump();

      expect(
        find.text('استفاده از کلینیک تعمیرات نیازمند اشتراک ویژه است.'),
        findsOneWidget,
      );
    });
  });
}
