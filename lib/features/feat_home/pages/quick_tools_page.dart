// lib/features/feat_home/pages/quick_tools_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/features/feat_scanner/pages/product_scanner_page.dart';
import 'package:my_estahban_city/features/feat_product/pages/brands_page.dart';

class QuickToolsPage extends StatelessWidget {
  const QuickToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    bool isVip = user != null && user.tier != null && user.tier != 'free';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFDDE3F1),
        appBar: AppBar(
          title: const Text(
            'امکانات سریع و ابزارها',
            style: TextStyle(fontFamily: 'Vazir', fontSize: 18),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.blue,
                  size: 28,
                ),
                title: const Text(
                  'اسکن بارکد محصول',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'اسکن سریع بارکد برای یافتن کالا',
                  style: TextStyle(fontFamily: 'Vazir', fontSize: 12),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pushNamed(context, ProductScannerPage.routeName);
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: const Icon(
                  Icons.branding_watermark,
                  color: Colors.orange,
                  size: 28,
                ),
                title: const Row(
                  children: [
                    Text(
                      'برندها و مدل‌ها',
                      style: TextStyle(
                        fontFamily: 'Vazir',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Chip(
                      label: Text(
                        'VIP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'Vazir',
                        ),
                      ),
                      backgroundColor: Colors.amber,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                subtitle: const Text(
                  'مشاهده دسته‌بندی برندها و مدل محصولات',
                  style: TextStyle(fontFamily: 'Vazir', fontSize: 12),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if (!isVip) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'مشاهده برندها نیازمند اشتراک VIP است.',
                          style: TextStyle(fontFamily: 'Vazir'),
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BrandsPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
