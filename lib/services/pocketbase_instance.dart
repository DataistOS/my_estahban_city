// lib/pocketbase_instance.dart

import 'package:pocketbase/pocketbase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

late PocketBase pocketBaseInstance;

Future<void> initializePocketBase() async {
  await dotenv.load(fileName: ".env");

  final pocketbaseUrl = dotenv.env['POCKETBASE_URL'];
  if (pocketbaseUrl == null) {
    throw Exception("POCKETBASE_URL not found in .env file");
  }

  pocketBaseInstance = PocketBase(pocketbaseUrl);
}
