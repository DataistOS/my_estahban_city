// lib/pages/login_page.dart

import 'package:rive/rive.dart' hide LinearGradient;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_estahban_city/services/auth_service.dart';

import '../../feat_home/pages/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nationalCodeController = TextEditingController();
  final _passwordController = TextEditingController();

  SMIBool? _isHandsUp;
  SMIBool? _isChecking;
  SMIBool? _isSuccess;
  SMIBool? _isFail;

  StateMachineController? _stateMachineController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthService>(context, listen: false).clearError();
    });
  }

  void _onRiveInit(Artboard artboard) {
    _stateMachineController = artboard.stateMachineByName('Login Machine');

    if (_stateMachineController != null) {
      artboard.addController(_stateMachineController!);

      _isChecking =
          _stateMachineController!.findInput<bool>('isChecking') as SMIBool?;
      _isHandsUp =
          _stateMachineController!.findInput<bool>('isHandsUp') as SMIBool?;
      _isSuccess =
          _stateMachineController!.findInput<bool>('isSuccess') as SMIBool?;
      _isFail = _stateMachineController!.findInput<bool>('isFail') as SMIBool?;
    }
  }

  @override
  void dispose() {
    _nationalCodeController.dispose();
    _passwordController.dispose();
    _stateMachineController?.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);

      _isSuccess?.value = false;
      _isFail?.value = false;
      _isChecking?.value = false;
      _isHandsUp?.value = false;

      await Future.delayed(const Duration(milliseconds: 500));

      try {
        await authService.login(
          _nationalCodeController.text.trim(),
          _passwordController.text,
        );
        if (!mounted) return;

        if (authService.currentUser != null) {
          _isSuccess?.value = true;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          _isFail?.value = true;
        }
      } catch (e) {
        _isFail?.value = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE3F1),
      body: Consumer<AuthService>(
        builder: (context, authService, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 250,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..scale(-1.0, 1.0),
                          child: RiveAnimation.asset(
                            'assets/animations/bear.riv',
                            fit: BoxFit.contain,
                            onInit: _onRiveInit,
                          ),
                        ),
                      ),
                      const Text(
                        'ورود به حساب کاربری',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                          fontFamily: 'Vazir',
                        ),
                      ),
                      const SizedBox(height: 48),

                      TextFormField(
                        controller: _nationalCodeController,
                        style: const TextStyle(
                          color: Color(0xFF333333),
                          fontFamily: 'Vazir',
                        ),
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          labelText: 'کد ملی',
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Vazir',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: const Icon(
                            Icons.credit_card,
                            color: Colors.grey,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onTap: () {
                          _isHandsUp?.value = false;
                          _isChecking?.value = true;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا کد ملی خود را وارد کنید';
                          }
                          if (value.length != 10) {
                            return 'کد ملی باید ۱۰ رقم باشد';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(
                          color: Color(0xFF333333),
                          fontFamily: 'Vazir',
                        ),
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          labelText: 'رمز عبور',
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Vazir',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: const Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () {
                          _isChecking?.value = false;
                          _isHandsUp?.value = true;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'لطفا رمز عبور خود را وارد کنید';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Error Message
                      if (authService.errorMessage != null)
                        Text(
                          authService.errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Vazir',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 16),

                      // Login Button
                      authService.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF333333),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF333333),
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'ورود',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Vazir',
                                ),
                              ),
                            ),
                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: () async {
                          final Uri url = Uri.parse('https://idna.dataist.ir');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        child: const Text(
                          'هنوز حساب کاربری ندارید؟ ثبت‌نام کنید.',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Vazir',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
