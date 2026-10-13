// test/features/feat_services/pages/request_service_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_estahban_city/features/feat_services/pages/request_service_page.dart';
import 'package:my_estahban_city/features/feat_services/models/service_model.dart';
import 'package:my_estahban_city/features/feat_services/models/equipment_model.dart';
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
  List<EquipmentModel> userEquipments = [
    EquipmentModel(
      id: 'eq_1',
      user: 'user_123',
      title: 'لپ‌تاپ دل',
      created: DateTime.now(),
      updated: DateTime.now(),
    ),
  ];

  @override
  bool isActionLoading = false;

  @override
  String? errorMessage;

  @override
  Future<void> fetchUserEquipments(String userId) async {}

  @override
  Future<bool> submitRepairRequest({
    required String userId,
    required String userTier,
    required String serviceId,
    required String equipmentId,
    required String issueDescription,
  }) async {
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  ServiceModel createTestService() {
    return ServiceModel(
      id: 'srv_1',
      title: 'سرویس دوره‌ای کولر',
      description: 'تعویض پوشال و تنظیم موتور',
      basePrice: 300000.0,
      isActive: true,
      created: DateTime.now(),
      updated: DateTime.now(),
    );
  }

  Widget createTestableWidget({
    required ServiceModel service,
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
      child: MaterialApp(home: RequestServicePage(service: service)),
    );
  }

  group('RequestServicePage Widget Tests', () {
    testWidgets('renders service details and form elements correctly', (
      WidgetTester tester,
    ) async {
      final service = createTestService();

      await tester.pumpWidget(createTestableWidget(service: service));
      await tester.pumpAndSettle();

      expect(find.text('ثبت درخواست: سرویس دوره‌ای کولر'), findsOneWidget);
      expect(find.text('تعویض پوشال و تنظیم موتور'), findsOneWidget);
      expect(find.text('هزینه پایه: 300000.0 تومان'), findsOneWidget);

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('ثبت نهایی درخواست'), findsOneWidget);
    });

    testWidgets('shows validation error when submitting empty description', (
      WidgetTester tester,
    ) async {
      final service = createTestService();

      await tester.pumpWidget(createTestableWidget(service: service));
      await tester.pumpAndSettle();

      await tester.tap(find.text('ثبت نهایی درخواست'));
      await tester.pump();

      expect(find.text('لطفاً توضیحات مشکل را وارد کنید'), findsOneWidget);
    });
  });
}
