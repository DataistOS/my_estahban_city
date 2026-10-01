// lib/features/feat_auth/pages/login_page.dart

import 'package:rive/rive.dart' hide LinearGradient;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/features/feat_home/pages/home_page.dart';
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

  static RiveFile? _cachedRiveFile;
  bool _isRiveLoaded = false;
  Artboard? _artboard;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthService>(context, listen: false).clearError();
    });
    _loadRiveFile();
  }

  Future<void> _loadRiveFile() async {
    if (_cachedRiveFile != null) {
      _initArtboard(_cachedRiveFile!);
      return;
    }
    try {
      _cachedRiveFile = await RiveFile.asset('assets/animations/bear.riv');
      _initArtboard(_cachedRiveFile!);
    } catch (_) {
    }
  }

  void _initArtboard(RiveFile file) {
    final artboard = file.mainArtboard;
    final controller = StateMachineController.fromArtboard(
      artboard,
      'Login Machine',
    );

    if (controller != null) {
      artboard.addController(controller);
      _stateMachineController = controller;

      _isChecking = controller.findInput<bool>('isChecking') as SMIBool?;
      _isHandsUp = controller.findInput<bool>('isHandsUp') as SMIBool?;
      _isSuccess = controller.findInput<bool>('isSuccess') as SMIBool?;
      _isFail = controller.findInput<bool>('isFail') as SMIBool?;
    }

    if (mounted) {
      setState(() {
        _artboard = artboard;
        _isRiveLoaded = true;
      });
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
      if (!mounted) return;

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
        if (!mounted) return;
        _isFail?.value = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFDDE3F1),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Consumer<AuthService>(
          builder: (context, authService, child) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RepaintBoundary(
                        child: SizedBox(
                          height: 220,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..scale(-1.0, 1.0),
                            child: _isRiveLoaded && _artboard != null
                                ? Rive(
                                    artboard: _artboard!,
                                    fit: BoxFit.contain,
                                  )
                                : const SizedBox.shrink(),
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
                      const SizedBox(height: 36),

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
            );
          },
        ),
      ),
    );
  }
}
