// test/features/feat_services/pages/services_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_estahban_city/features/feat_services/pages/services_page.dart';
import 'package:my_estahban_city/features/feat_services/models/service_model.dart';
import 'package:my_estahban_city/features/feat_services/services/services_provider.dart';

class FakeServicesProvider extends ChangeNotifier implements ServicesProvider {
  @override
  List<ServiceModel> services = [];

  @override
  bool isLoading = false;

  @override
  String? errorMessage;

  FakeServicesProvider({
    List<ServiceModel>? initialServices,
    this.isLoading = false,
    this.errorMessage,
  }) {
    if (initialServices != null) {
      services = initialServices;
    }
  }

  @override
  Future<void> fetchServices() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestableWidget({ServicesProvider? servicesProvider}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ServicesProvider>.value(
          value: servicesProvider ?? FakeServicesProvider(),
        ),
      ],
      child: const MaterialApp(home: ServicesPage()),
    );
  }

  group('ServicesPage Widget Tests', () {
    testWidgets('renders shimmer loading state when loading is true', (
      WidgetTester tester,
    ) async {
      final provider = FakeServicesProvider(isLoading: true);

      await tester.pumpWidget(createTestableWidget(servicesProvider: provider));

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('renders services grouped by category successfully', (
      WidgetTester tester,
    ) async {
      final sampleServices = [
        ServiceModel(
          id: 'srv_1',
          title: 'تعمیر موتور خودرو',
          category: 'car',
          basePrice: 500000.0,
          description: 'عیب‌یابی تخصصی موتور',
          isActive: true,
          created: DateTime.now(),
          updated: DateTime.now(),
        ),
      ];

      final provider = FakeServicesProvider(initialServices: sampleServices);

      await tester.pumpWidget(createTestableWidget(servicesProvider: provider));
      await tester.pumpAndSettle();

      expect(find.text('کلینیک و خدمات تعمیراتی'), findsOneWidget);
      expect(find.text('خدمات خودرو'), findsOneWidget);
      expect(find.text('تعمیر موتور خودرو'), findsOneWidget);
      expect(find.text('500000.0 ت'), findsOneWidget);
    });

    testWidgets('renders empty state when services list is empty', (
      WidgetTester tester,
    ) async {
      final provider = FakeServicesProvider(initialServices: []);

      await tester.pumpWidget(createTestableWidget(servicesProvider: provider));
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
