// lib/services/auth_service.dart
import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

import 'package:my_estahban_city/features/feat_auth/models/user_model.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

class AuthService with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  AuthService() {
    pocketBaseInstance.authStore.onChange.listen((token) async {
      _fetchCurrentUser();
    });
    _fetchCurrentUser();
  }

  void _fetchCurrentUser() {
    final user = pocketBaseInstance.authStore.record;
    if (user != null) {
      try {
        _currentUser = UserModel.fromRecord(user);
        if (kDebugMode) {
          print('Current user fetched successfully.');
        }
      } catch (e) {
        if (kDebugMode) {
          print(
            'CRITICAL: UserModel.fromRecord failed during _fetchCurrentUser: $e',
          );
          print(
            'User model creation failed, treating current user as null for safety.',
          );
        }
        _currentUser = null;
      }
    } else {
      _currentUser = null;
    }
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> login(String nationalCodeOrIdentifier, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final authData = await pocketBaseInstance
          .collection('users')
          .authWithPassword(nationalCodeOrIdentifier, password);
      _currentUser = UserModel.fromRecord(authData.record);
      if (kDebugMode) {
        print('Login successful, user: $_currentUser');
      }
    } on ClientException catch (e) {
      _errorMessage = e.response['message'] ?? 'کد ملی یا رمز عبور اشتباه است.';
      if (kDebugMode) {
        print(
          'PocketBase Client Error: Status ${e.response['status'] ?? 400} - ${e.response['message']}',
        );
      }
    } catch (e) {
      _errorMessage = 'خطای ناشناخته رخ داد. لطفاً دوباره تلاش کنید.';
      if (kDebugMode) {
        print('Unknown Error Details: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(Map<String, dynamic> userData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final authData = await pocketBaseInstance
          .collection('users')
          .create(body: userData);
      _currentUser = UserModel.fromRecord(authData);
      if (kDebugMode) {
        print('Registration successful, user: $_currentUser');
      }
    } on ClientException catch (e) {
      _errorMessage = e.response['message'] ?? 'خطا در ثبت‌نام رخ داد.';
      if (kDebugMode) {
        print(
          'PocketBase Client Error: Status ${e.response['status'] ?? 400} - ${e.response['message']}',
        );
      }
    } catch (e) {
      if (_currentUser != null) {
        if (kDebugMode) {
          print(
            'Non-critical error suppressed after successful registration: $e',
          );
        }
      } else {
        _errorMessage = 'خطای ناشناخته در ثبت‌نام. لطفاً دوباره تلاش کنید.';
        if (kDebugMode) {
          print('Unknown Registration Error: $e');
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    pocketBaseInstance.authStore.clear();
    _currentUser = null;
    notifyListeners();
  }
}
