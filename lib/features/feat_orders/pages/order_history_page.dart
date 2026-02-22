// lib/features/feat_product/order_history_page.dart

import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تاریخچه سفارشات', style: TextStyle(fontFamily: 'Vazir')),
        ),
        body: const Center(
          child: Text(
            'این صفحه برای نمایش تاریخچه سفارشات است.',
            style: TextStyle(fontFamily: 'Vazir', fontSize: 18),
          ),
        ),
      ),
    );
  }
}