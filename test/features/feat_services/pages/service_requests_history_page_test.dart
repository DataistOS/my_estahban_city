// test/features/feat_services/pages/service_requests_history_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_estahban_city/features/feat_services/pages/service_requests_history_page.dart';
import 'package:my_estahban_city/features/feat_services/models/service_request_model.dart';
import 'package:my_estahban_city/features/feat_services/services/services_provider.dart';
import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/features/feat_auth/models/user_model.dart';

class FakeAuthService extends ChangeNotifier implements AuthService {
  final UserModel? _currentUser;

  FakeAuthService({UserModel? initialUser}) : _currentUser = initialUser;

  @override
  UserModel? get currentUser => _currentUser;

  @override
  bool get isAuthenticated => _currentUser != null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeServicesProvider extends ChangeNotifier implements ServicesProvider {
  @override
  List<ServiceRequestModel> userRequests = [];

  @override
  bool isLoading = false;

  FakeServicesProvider({List<ServiceRequestModel>? initialRequests}) {
    if (initialRequests != null) {
      userRequests = initialRequests;
    }
  }

  @override
  Future<void> fetchUserRequests(String userId) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestableWidget({
    AuthService? authService,
    ServicesProvider? servicesProvider,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(
          value:
              authService ??
              FakeAuthService(
                initialUser: UserModel(
                  id: 'user_123',
                  email: 'test@example.com',
                  name: 'تست کاربر',
                  avatar: '',
                  created: DateTime.now(),
                  updated: DateTime.now(),
                ),
              ),
        ),
        ChangeNotifierProvider<ServicesProvider>.value(
          value: servicesProvider ?? FakeServicesProvider(),
        ),
      ],
      child: const MaterialApp(home: ServiceRequestsHistoryPage()),
    );
  }

  group('ServiceRequestsHistoryPage Widget Tests', () {
    testWidgets('renders empty state when user has no requests', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('تاریخچه درخواست‌های تعمیر'), findsOneWidget);
      expect(find.text('تاکنون درخواستی ثبت نکرده‌اید.'), findsOneWidget);
      expect(find.text('بروزرسانی'), findsOneWidget);
    });

    testWidgets('renders requests list and status badge correctly', (
      WidgetTester tester,
    ) async {
      final sampleRequests = [
        ServiceRequestModel(
          id: 'req_123456789',
          user: 'user_123',
          service: 'srv_1',
          equipment: 'eq_1',
          issueDescription: 'مشکل عدم روشن شدن لپ‌تاپ',
          images: [],
          status: 'pending',
          created: DateTime.now(),
          updated: DateTime.now(),
        ),
      ];

      final provider = FakeServicesProvider(initialRequests: sampleRequests);

      await tester.pumpWidget(createTestableWidget(servicesProvider: provider));
      await tester.pumpAndSettle();

      expect(find.text('کد درخواست: req_12'), findsOneWidget);
      expect(find.text('در انتظار بررسی'), findsOneWidget);
      expect(find.text('مشکل عدم روشن شدن لپ‌تاپ'), findsOneWidget);

      expect(find.byIcon(Icons.delete_sweep), findsOneWidget);
    });

    testWidgets('shows confirmation dialog when tapping clear history button', (
      WidgetTester tester,
    ) async {
      final sampleRequests = [
        ServiceRequestModel(
          id: 'req_123456789',
          user: 'user_123',
          service: 'srv_1',
          equipment: 'eq_1',
          issueDescription: 'تست حذف',
          images: [],
          status: 'completed',
          created: DateTime.now(),
          updated: DateTime.now(),
        ),
      ];

      final provider = FakeServicesProvider(initialRequests: sampleRequests);

      await tester.pumpWidget(createTestableWidget(servicesProvider: provider));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_sweep));
      await tester.pumpAndSettle();

      expect(find.text('پاک کردن تاریخچه'), findsOneWidget);
      expect(
        find.text(
          'آیا مطمئن هستید که می‌خواهید تاریخچه درخواست‌های تعمیر را پاک کنید؟',
        ),
        findsOneWidget,
      );
      expect(find.text('انصراف'), findsOneWidget);
      expect(find.text('پاک کردن'), findsOneWidget);
    });
  });
}
