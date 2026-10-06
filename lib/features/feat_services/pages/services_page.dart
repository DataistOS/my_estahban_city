// lib/features/feat_services/pages/services_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/services_provider.dart';
import 'request_service_page.dart';
import 'service_requests_history_page.dart';
import '../../../core/widgets/product_shimmer_loading.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'کلینیک و خدمات تعمیراتی',
          style: TextStyle(fontFamily: 'Vazir'),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_edu_rounded),
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
          if (provider.isLoading) {
            return const Padding(
              padding: EdgeInsets.all(12.0),
              child: ProductShimmerLoading(),
            );
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
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontFamily: 'Vazir'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => provider.fetchServices(),
                      icon: const Icon(Icons.refresh),
                      label: const Text(
                        'تلاش مجدد',
                        style: TextStyle(fontFamily: 'Vazir'),
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
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Vazir',
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchServices(),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.services.length,
              itemBuilder: (context, index) {
                final service = provider.services[index];
                final imageUrl = service.image;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: imageUrl != null && imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.build, color: Colors.grey),
                              ),
                            )
                          : const Icon(Icons.build, color: Colors.blue),
                    ),
                    title: Text(
                      service.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Vazir',
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        service.description ?? 'بدون توضیحات',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontFamily: 'Vazir',
                        ),
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (service.basePrice != null)
                          Text(
                            '${service.basePrice} تومان',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 13,
                              fontFamily: 'Vazir',
                            ),
                          ),
                        const SizedBox(height: 4),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
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
              },
            ),
          );
        },
      ),
    );
  }
}
