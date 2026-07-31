// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';
import 'package:my_estahban_city/services/product_service.dart';

import 'features/feat_auth/pages/login_page.dart';
import 'features/feat_home/pages/home_page.dart';
import 'features/feat_intro/pages/splash_screen.dart';
import 'features/feat_product/pages/request_product_page.dart';
import 'features/feat_scanner/pages/product_scanner_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializePocketBase();

  final prefs = await SharedPreferences.getInstance();
  final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  String initialRoute = '/splash';
  if (hasSeenOnboarding) {
    initialRoute = '/home';
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => ProductService()),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'استهبان‌من | همراه هوشمند شهروندان',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: initialRoute,
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/request-product': (context) => const RequestProductPage(),
        ProductScannerPage.routeName: (context) => const ProductScannerPage(),
      },
    );
  }
}
