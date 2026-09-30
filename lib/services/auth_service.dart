// lib/services/auth_service.dart

import 'package:flutter/foundation.dart';

import 'package:my_estahban_city/features/feat_auth/models/user_model.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';
import 'package:my_estahban_city/core/errors/pocketbase_error_handler.dart';

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
          debugPrint('Current user fetched successfully.');
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint(
            'CRITICAL: UserModel.fromRecord failed during _fetchCurrentUser: $e',
          );
          debugPrint(
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
        debugPrint('Login successful, user: $_currentUser');
      }
    } catch (e) {
      _errorMessage = getFriendlyErrorMessage(e);
      if (kDebugMode) {
        debugPrint('Login Error Details: $e');
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
        debugPrint('Registration successful, user: $_currentUser');
      }
    } catch (e) {
      if (_currentUser != null) {
        if (kDebugMode) {
          debugPrint(
            'Non-critical error suppressed after successful registration: $e',
          );
        }
      } else {
        _errorMessage = getFriendlyErrorMessage(e);
        if (kDebugMode) {
          debugPrint('Registration Error Details: $e');
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
