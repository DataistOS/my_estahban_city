// test/features/feat_home/pages/home_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:my_estahban_city/features/feat_home/pages/home_page.dart';
import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/features/feat_auth/models/user_model.dart';
import 'package:my_estahban_city/features/feat_search/widgets/search_widget.dart';
import 'package:my_estahban_city/features/feat_home/widgets/home_product_list.dart';

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

  Widget createHomePage() {
    return ChangeNotifierProvider<AuthService>.value(
      value: fakeAuthService,
      child: const MaterialApp(home: HomePage()),
    );
  }

  group('HomePage Widget Tests', () {
    testWidgets('renders HomePage with default elements correctly', (
      WidgetTester tester,
    ) async {
      fakeAuthService.currentUser = null;

      await tester.pumpWidget(createHomePage());
      await tester.pump();

      expect(find.text('استهبان‌من (ویترین)'), findsOneWidget);

      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);

      expect(
        find.textContaining('شما در حال مشاهده ویترین هستید'),
        findsOneWidget,
      );

      expect(find.byType(SearchWidget), findsOneWidget);

      expect(find.byType(HomeProductList), findsOneWidget);

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner), findsAtLeastNWidgets(1));
    });

    testWidgets('opens quick tools bottom sheet when FAB is pressed', (
      WidgetTester tester,
    ) async {
      fakeAuthService.currentUser = null;

      await tester.pumpWidget(createHomePage());
      await tester.pump();

      final fab = find.byType(FloatingActionButton);
      await tester.tap(fab);
      await tester.pumpAndSettle();

      expect(find.text('ابزارهای سریع'), findsOneWidget);
      expect(find.text('اسکن بارکد'), findsOneWidget);
      expect(find.text('سایر امکانات'), findsOneWidget);
    });
  });
}
