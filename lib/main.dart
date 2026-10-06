// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/services/product_service.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

import 'package:my_estahban_city/features/feat_services/services/services_provider.dart';

import 'features/feat_home/pages/home_page.dart';
import 'features/feat_auth/pages/login_page.dart';
import 'features/feat_intro/pages/splash_screen.dart';
import 'features/feat_product/pages/request_product_page.dart';
import 'features/feat_scanner/pages/product_scanner_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializePocketBase();

  const String initialRoute = '/home';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => ServicesProvider()),
      ],
      child: const MyApp(initialRoute: initialRoute),
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
      locale: const Locale('fa', 'IR'),
      supportedLocales: const [Locale('fa', 'IR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Vazir',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Vazir',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
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
