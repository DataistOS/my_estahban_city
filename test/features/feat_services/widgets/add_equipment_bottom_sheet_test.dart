// test/features/feat_services/widgets/add_equipment_bottom_sheet_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_estahban_city/features/feat_services/widgets/add_equipment_bottom_sheet.dart';
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
  bool isActionLoading = false;

  @override
  Future<bool> addNewEquipment(Map<String, dynamic> data) async {
    return true;
  }

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
      child: const MaterialApp(home: Scaffold(body: AddEquipmentBottomSheet())),
    );
  }

  group('AddEquipmentBottomSheet Widget Tests', () {
    testWidgets('renders all form fields and submit button correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('افزودن تجهیز یا خودروی جدید'), findsOneWidget);
      expect(find.text('نوع تجهیز'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.text('ثبت تجهیز'), findsOneWidget);
    });

    testWidgets('shows validation error when submitting empty title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('ثبت تجهیز'));
      await tester.pump();

      expect(find.text('لطفاً عنوان را وارد کنید'), findsOneWidget);
    });
  });
}
