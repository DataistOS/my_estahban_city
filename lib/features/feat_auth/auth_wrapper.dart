// lib/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/features/feat_auth/pages/login_page.dart';
import 'package:my_estahban_city/features/feat_intro/pages/splash_screen.dart';

import '../feat_home/pages/home_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    if (authService.isLoading) {
      return const SplashScreen();
    }

    if (authService.currentUser != null) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
