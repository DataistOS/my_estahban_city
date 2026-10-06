// lib/features/feat_services/pages/service_requests_history_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/services_provider.dart';
import '../../../services/auth_service.dart';

class ServiceRequestsHistoryPage extends StatefulWidget {
  const ServiceRequestsHistoryPage({super.key});

  @override
  State<ServiceRequestsHistoryPage> createState() =>
      _ServiceRequestsHistoryPageState();
}

class _ServiceRequestsHistoryPageState
    extends State<ServiceRequestsHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchRequests();
    });
  }

  void _fetchRequests() {
    final userId = context.read<AuthService>().currentUser?.id;
    if (userId != null && userId.isNotEmpty) {
      context.read<ServicesProvider>().fetchUserRequests(userId);
    }
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;

    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        text = 'در انتظار بررسی';
        break;
      case 'in_progress':
        color = Colors.blue;
        text = 'در حال انجام';
        break;
      case 'completed':
        color = Colors.green;
        text = 'تکمیل شده';
        break;
      case 'cancelled':
        color = Colors.red;
        text = 'لغو شده';
        break;
      default:
        color = Colors.grey;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          fontFamily: 'Vazir',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تاریخچه درخواست‌های تعمیر',
          style: TextStyle(fontFamily: 'Vazir'),
        ),
        centerTitle: true,
      ),
      body: Consumer<ServicesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.userRequests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.history_toggle_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'تاکنون درخواستی ثبت نکرده‌اید.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Vazir',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _fetchRequests,
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      'بروزرسانی',
                      style: TextStyle(fontFamily: 'Vazir'),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _fetchRequests(),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.userRequests.length,
              itemBuilder: (context, index) {
                final request = provider.userRequests[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'کد درخواست: ${request.id.length > 6 ? request.id.substring(0, 6) : request.id}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.grey,
                                fontFamily: 'Vazir',
                              ),
                            ),
                            _buildStatusBadge(request.status),
                          ],
                        ),
                        const Divider(height: 20),
                        const Text(
                          'توضیحات مشکل:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'Vazir',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          request.issueDescription,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontFamily: 'Vazir',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'تاریخ: ${request.created.toLocal().toString().substring(0, 16)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                fontFamily: 'Vazir',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
