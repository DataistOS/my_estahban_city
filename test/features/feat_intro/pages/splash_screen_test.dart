// test/feat_intro/pages/splash_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_estahban_city/features/feat_intro/pages/splash_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('SplashScreen Widget Tests', () {
    testWidgets(
      'renders onboarding pages and navigates through them correctly',
      (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SplashScreen()));

        await tester.pump();

        expect(find.text('خوش آمدید.'), findsOneWidget);
        expect(find.text('بعدی'), findsOneWidget);
        expect(find.text('شروع کنید'), findsNothing);

        await tester.tap(find.text('بعدی'));
        await tester.pumpAndSettle();

        expect(find.text('هدف و مأموریت:'), findsOneWidget);

        await tester.tap(find.text('بعدی'));
        await tester.pumpAndSettle();

        expect(find.text('دعوت:'), findsOneWidget);
        expect(find.text('شروع کنید'), findsOneWidget);
        expect(find.text('بعدی'), findsNothing);
      },
    );

    testWidgets(
      'saves preference and navigates to home when start button is pressed',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            routes: {
              '/home': (context) => const Scaffold(body: Text('Home Screen')),
            },
            home: SplashScreen(),
          ),
        );

        await tester.pump();

        await tester.tap(find.text('بعدی'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('بعدی'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('شروع کنید'));
        await tester.pumpAndSettle();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('hasSeenOnboarding'), true);

        expect(find.text('Home Screen'), findsOneWidget);
      },
    );
  });
}
