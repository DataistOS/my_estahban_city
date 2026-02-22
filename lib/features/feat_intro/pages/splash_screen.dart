// lib/feat_intro/splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../feat_auth/pages/login_page.dart';
import '../../feat_home/pages/home_page.dart';
import '../../../services/auth_service.dart';
import '../../../core/widgets/no_connection_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  final int _numPages = 3;
  int _currentPage = 0;
  bool _isConnected = true;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  static const Color _mainBackgroundColor = Color(0xFFDDE3F1);
  static const Color _primaryTextColor = Color(0xFF333333);
  static const double _bottomPadding = 40.0;
  static const double _sidePadding = 24.0;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (mounted) {
        _checkConnectivity();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _isConnected = !connectivityResult.contains(ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnected) {
      return const NoConnectionWidget(backgroundColor: _mainBackgroundColor);
    }

    return Scaffold(
      backgroundColor: _mainBackgroundColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: <Widget>[
            PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: <Widget>[
                _buildPage(
                  'خوش آمدید.',
                  'اپلیکیشن شهروندی استهبان‌من در دو بخش (ویترین شهرستان استهبان) و دسترسی به (خدمات کامل شهروندی استهبان) در اختیار شما قرار می‌گیرد.',
                  'assets/images/onboarding1.svg',
                ),
                _buildPage(
                  'وظیفه‌ ما:',
                  'ما ملزم به مهیا کردن نهایت خدمات شهروندی با کیفیت به مردم استهبان و در اخیار قرار دادن محصولات تولیدی استهبان به مردم دنیا هستیم',
                  'assets/images/onboarding2.svg',
                ),
                _buildPage(
                  'نکته:',
                  'لطفا برای استفاده از تمام خدمات اپلیکیشن استهبان‌من, احرازهویت خودتان را کامل نمایید.',
                  'assets/images/onboarding3.svg',
                ),
              ],
            ),

            Positioned(
              bottom: _bottomPadding,
              left: _sidePadding,
              child: _currentPage == _numPages - 1
                  ? TextButton(
                      onPressed: () {
                        final authService = Provider.of<AuthService>(
                          context,
                          listen: false,
                        );
                        if (authService.currentUser != null) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: _primaryTextColor,
                      ),
                      child: const Text(
                        'شروع کنید',
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : TextButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: _primaryTextColor,
                      ),
                      child: const Text(
                        'بعدی',
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(String title, String description, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            width: 250,
            child: SvgPicture.asset(imagePath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 32),
          SmoothPageIndicator(
            controller: _pageController,
            count: _numPages,
            effect: const WormEffect(
              dotHeight: 10,
              dotWidth: 10,
              activeDotColor: _primaryTextColor,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Vazir',
              color: _primaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: _primaryTextColor,
              fontFamily: 'Vazir',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
