// lib/features/feat_services/pages/service_requests_history_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';
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
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  bool _isClearing = false;

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

  Future<void> _clearServerHistory(List<dynamic> allRequests) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text(
            'پاک کردن تاریخچه',
            style: TextStyle(fontFamily: 'Vazir'),
          ),
          content: const Text(
            'آیا مطمئن هستید که می‌خواهید تاریخچه درخواست‌های تعمیر را پاک کنید؟',
            style: TextStyle(fontFamily: 'Vazir'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'انصراف',
                style: TextStyle(fontFamily: 'Vazir'),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'پاک کردن',
                style: TextStyle(fontFamily: 'Vazir', color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirm == true) {
      setState(() {
        _isClearing = true;
      });

      try {
        for (var request in allRequests) {
          await pocketBaseInstance
              .collection('srv_requests')
              .update(request.id, body: {'is_deleted': true});
        }

        setState(() {
          _currentPage = 0;
          _isClearing = false;
        });

        _fetchRequests();
      } catch (e) {
        setState(() {
          _isClearing = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'خطا در پاک کردن تاریخچه: $e',
              style: const TextStyle(fontFamily: 'Vazir'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تاریخچه درخواست‌های تعمیر',
            style: TextStyle(fontFamily: 'Vazir'),
          ),
          centerTitle: true,
          actions: [
            Consumer<ServicesProvider>(
              builder: (context, provider, child) {
                if (provider.userRequests.isEmpty || _isClearing) {
                  return const SizedBox.shrink();
                }

                return IconButton(
                  icon: const Icon(Icons.delete_sweep, color: Colors.red),
                  tooltip: 'پاک کردن تاریخچه',
                  onPressed: () => _clearServerHistory(provider.userRequests),
                );
              },
            ),
          ],
        ),
        body: _isClearing
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text(
                      'در حال پاکسازی...',
                      style: TextStyle(fontFamily: 'Vazir'),
                    ),
                  ],
                ),
              )
            : Consumer<ServicesProvider>(
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

                  final totalPages =
                      (provider.userRequests.length / _itemsPerPage).ceil();
                  if (_currentPage >= totalPages) {
                    _currentPage = totalPages > 0 ? totalPages - 1 : 0;
                  }

                  final startIndex = _currentPage * _itemsPerPage;
                  final endIndex =
                      (startIndex + _itemsPerPage <
                          provider.userRequests.length)
                      ? startIndex + _itemsPerPage
                      : provider.userRequests.length;
                  final paginatedRequests = provider.userRequests.sublist(
                    startIndex,
                    endIndex,
                  );

                  return RefreshIndicator(
                    onRefresh: () async => _fetchRequests(),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: paginatedRequests.length,
                            itemBuilder: (context, index) {
                              final request = paginatedRequests[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                        ),
                        if (totalPages > 1)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: _currentPage < totalPages - 1
                                      ? () => setState(() => _currentPage++)
                                      : null,
                                ),
                                Text(
                                  'صفحه ${_currentPage + 1} از $totalPages',
                                  style: const TextStyle(
                                    fontFamily: 'Vazir',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_left),
                                  onPressed: _currentPage > 0
                                      ? () => setState(() => _currentPage--)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
