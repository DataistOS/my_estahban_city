// lib/features/feat_orders/pages/order_history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // اضافه شده برای خواندن متغیرهای محیطی
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_estahban_city/features/feat_product/models/order_model.dart';
import 'package:my_estahban_city/features/feat_product/models/product_model.dart';
import 'package:my_estahban_city/services/cart_service.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final CartService _cartService = CartService();

  late Future<List<OrderModel>> _ordersFuture = _cartService.getOrders();

  List<String> _hiddenOrderIds = [];
  int _currentPage = 0;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadHiddenOrdersAndFetch();
  }

  Future<void> _loadHiddenOrdersAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    _hiddenOrderIds = prefs.getStringList('hidden_orders') ?? [];
    setState(() {
      _ordersFuture = _cartService.getOrders();
    });
  }

  Future<void> _clearLocalHistory(List<OrderModel> allOrders) async {
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
            'آیا مطمئن هستید که می‌خواهید تاریخچه سفارش‌ها را از دستگاه خود پاک کنید؟',
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
      final prefs = await SharedPreferences.getInstance();
      final allIds = allOrders.map((o) => o.id).toList();
      _hiddenOrderIds.addAll(allIds);
      await prefs.setStringList('hidden_orders', _hiddenOrderIds);
      setState(() {
        _currentPage = 0;
      });
    }
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'pending':
        return 'در انتظار پرداخت';
      case 'processing':
        return 'در حال پردازش';
      case 'shipped':
        return 'ارسال شده';
      case 'delivered':
        return 'تحویل داده شده';
      case 'canceled':
        return 'لغو شده';
      case 'refunded':
        return 'مرجوع شده';
      default:
        return 'نامشخص';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'canceled':
      case 'refunded':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFDDE3F1),
        appBar: AppBar(
          title: const Text(
            'تاریخچه سفارشات',
            style: TextStyle(fontFamily: 'Vazir', color: Color(0xFF333333)),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            FutureBuilder<List<OrderModel>>(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty)
                  return const SizedBox.shrink();
                final visibleOrders = snapshot.data!
                    .where((o) => !_hiddenOrderIds.contains(o.id))
                    .toList();

                if (visibleOrders.isEmpty) return const SizedBox.shrink();

                return IconButton(
                  icon: const Icon(Icons.delete_sweep, color: Colors.red),
                  tooltip: 'پاک کردن تاریخچه محلی',
                  onPressed: () => _clearLocalHistory(visibleOrders),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder<List<OrderModel>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('خطا: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Column(
                children: [
                  _buildPaymentInfoBanner(context),
                  // نمایش بنر حتی وقتی سفارشی ثبت نشده تا کاربر راهنمایی شود
                  const Expanded(
                    child: Center(
                      child: Text(
                        'شما تاکنون سفارشی ثبت نکرده‌اید.',
                        style: TextStyle(fontFamily: 'Vazir', fontSize: 16),
                      ),
                    ),
                  ),
                ],
              );
            }

            final visibleOrders = snapshot.data!
                .where((o) => !_hiddenOrderIds.contains(o.id))
                .toList();

            if (visibleOrders.isEmpty) {
              return Column(
                children: [
                  _buildPaymentInfoBanner(context),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'تاریخچه سفارشات خالی است.',
                        style: TextStyle(fontFamily: 'Vazir', fontSize: 16),
                      ),
                    ),
                  ),
                ],
              );
            }

            // صفحه‌بندی (Pagination)
            final totalPages = (visibleOrders.length / _itemsPerPage).ceil();
            if (_currentPage >= totalPages)
              _currentPage = totalPages > 0 ? totalPages - 1 : 0;

            final startIndex = _currentPage * _itemsPerPage;
            final endIndex = (startIndex + _itemsPerPage < visibleOrders.length)
                ? startIndex + _itemsPerPage
                : visibleOrders.length;
            final paginatedOrders = visibleOrders.sublist(startIndex, endIndex);

            return Column(
              children: [
                // بنر راهنمای پرداخت در بالای لیست سفارشات
                _buildPaymentInfoBanner(context),
                Expanded(
                  child: ListView.builder(
                    itemCount: paginatedOrders.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final order = paginatedOrders[index];
                      return _buildOrderCard(order);
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
            );
          },
        ),
      ),
    );
  }

  // ویجت بنر اطلاعات پرداخت کارت به کارت
  Widget _buildPaymentInfoBanner(BuildContext context) {
    final cardNumber =
        dotenv.env['SUPPORT_CARD_NUMBER'] ?? '۶۱۰۴-۳۳۷۹-xxxx-xxxx';
    final accountName =
        dotenv.env['SUPPORT_ACCOUNT_NAME'] ?? 'شرکت آزاد اندیش داده‌ساز';
    final phoneNumber = dotenv.env['SUPPORT_PHONE_NUMBER'] ?? '۰۹۱۲۳۴۵۶۷۸۹';

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline, color: Colors.amber, size: 20),
              SizedBox(width: 8),
              Text(
                'راهنمای پرداخت و تایید سفارش',
                style: TextStyle(
                  fontFamily: 'Vazir',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.brown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'شماره کارت: $cardNumber ($accountName)',
            style: const TextStyle(fontFamily: 'Vazir', fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            'لطفاً پس از ثبت و تایید سفارش، شماره قبض/پیگیری را به شماره $phoneNumber پیامک کنید.',
            style: const TextStyle(
              fontFamily: 'Vazir',
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'کد سفارش: ${order.id.substring(0, 8)}',
                  style: const TextStyle(
                    fontFamily: 'Vazir',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _translateStatus(order.status),
                    style: TextStyle(
                      fontFamily: 'Vazir',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(order.status),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            ...order.items.map((item) {
              return FutureBuilder<RecordModel?>(
                future: pocketBaseInstance
                    .collection('products')
                    .getOne(item.productId)
                    .catchError((_) => null),
                builder: (context, productSnapshot) {
                  if (!productSnapshot.hasData ||
                      productSnapshot.data == null) {
                    return const SizedBox.shrink();
                  }
                  final product = ProductModel.fromRecord(
                    productSnapshot.data!,
                  );

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            product.mainImage,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Vazir',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'تعداد: ${item.quantity}',
                                style: const TextStyle(
                                  fontFamily: 'Vazir',
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${(product.price * item.quantity).toInt()}',
                          style: const TextStyle(
                            fontFamily: 'Vazir',
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'مبلغ کل:',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${order.totalAmount.toInt()} تومان',
                  style: const TextStyle(
                    fontFamily: 'Vazir',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
