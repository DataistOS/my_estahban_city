// lib/features/feat_services/pages/services_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/services_provider.dart';
import 'request_service_page.dart';
import 'service_requests_history_page.dart';
import '../models/service_model.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServicesProvider>().fetchServices();
    });
  }

  String _getCategoryTitle(String categoryKey) {
    switch (categoryKey.toLowerCase()) {
      case 'car':
        return 'خدمات خودرو';
      case 'home_appliance':
        return 'لوازم خانگی';
      case 'electronic':
        return 'تجهیزات الکترونیکی';
      default:
        return 'سایر خدمات';
    }
  }

  Widget _buildServicesShimmer() {
    return ListView.builder(
      itemCount: 6,
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            title: Container(
              width: 120,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Container(
                width: 180,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            trailing: Container(
              width: 50,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'کلینیک و خدمات تعمیراتی',
          style: TextStyle(
            fontFamily: 'Vazir',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_edu_rounded, size: 22),
            tooltip: 'پیگیری و تاریخچه تعمیرات',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ServiceRequestsHistoryPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ServicesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading ||
              (provider.services.isEmpty && provider.errorMessage == null)) {
            return _buildServicesShimmer();
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontFamily: 'Vazir'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => provider.fetchServices(),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text(
                        'تلاش مجدد',
                        style: TextStyle(fontFamily: 'Vazir', fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.services.isEmpty) {
            return const Center(
              child: Text(
                'در حال حاضر هیچ خدماتی فعال نیست.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Vazir',
                ),
              ),
            );
          }

          final Map<String, List<ServiceModel>> groupedServices = {};
          for (var service in provider.services) {
            final category = service.category ?? 'other';
            groupedServices.putIfAbsent(category, () => []).add(service);
          }

          for (var entry in groupedServices.entries) {
            entry.value.sort((a, b) => a.title.compareTo(b.title));
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchServices(),
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: groupedServices.entries.map((entry) {
                final categoryKey = entry.key;
                final servicesList = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.label_important_outline,
                            size: 16,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _getCategoryTitle(categoryKey),
                            style: const TextStyle(
                              fontFamily: 'Vazir',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...servicesList.map((service) {
                      final imageUrl = service.image;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: imageUrl != null && imageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.build,
                                                color: Colors.grey,
                                                size: 20,
                                              ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.build,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                          ),
                          title: Text(
                            service.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'Vazir',
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Text(
                              service.description ?? 'بدون توضیحات',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                                fontFamily: 'Vazir',
                              ),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (service.basePrice != null)
                                Text(
                                  '${service.basePrice} ت',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontFamily: 'Vazir',
                                  ),
                                ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RequestServicePage(service: service),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
