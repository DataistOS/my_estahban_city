// lib/services/pocketbase_instance.dart

import 'dart:io';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class _MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

late PocketBase pocketBaseInstance;

Future<void> initializePocketBase() async {
  HttpOverrides.global = _MyHttpOverrides();

  await dotenv.load(fileName: ".env");

  final pocketbaseUrl = dotenv.env['POCKETBASE_URL'];
  if (pocketbaseUrl == null) {
    throw Exception("POCKETBASE_URL not found in .env file");
  }

  pocketBaseInstance = PocketBase(pocketbaseUrl);
}
