// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/main.dart';
import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';
import 'package:my_estahban_city/features/feat_auth/models/user_model.dart';

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
  Future<void> login(String nationalCode, String password) async {}

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() {
    pocketBaseInstance = PocketBase('http://127.0.0.1:8090');
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthService>(
        create: (_) => FakeAuthService(),
        child: const MyApp(initialRoute: '/login'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
