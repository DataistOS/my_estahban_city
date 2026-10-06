// lib/features/feat_home/pages/quick_tools_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/features/feat_scanner/pages/product_scanner_page.dart';
import 'package:my_estahban_city/features/feat_product/pages/brands_page.dart';
import 'package:my_estahban_city/features/feat_search/pages/advanced_search_page.dart';
import 'package:my_estahban_city/features/feat_services/pages/services_page.dart';

class QuickToolsPage extends StatelessWidget {
  const QuickToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

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
                  Icons.build_circle_rounded,
                  color: Colors.teal,
                  size: 28,
                ),
                title: const Text(
                  'کلینیک و خدمات تعمیراتی',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'ثبت درخواست تعمیر و مدیریت تجهیزات',
                  style: TextStyle(fontFamily: 'Vazir', fontSize: 12),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  final currentUser = authService.currentUser;
                  final bool currentIsVip =
                      currentUser != null &&
                      currentUser.tier != null &&
                      currentUser.tier != 'free';

                  if (!currentIsVip) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'استفاده از کلینیک تعمیرات نیازمند اشتراک ویژه است.',
                          style: TextStyle(fontFamily: 'Vazir'),
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServicesPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.5,
                children: [
                  InkWell(
                    onTap: () {
                      final currentUser = authService.currentUser;
                      final bool currentIsVip =
                          currentUser != null &&
                          currentUser.tier != null &&
                          currentUser.tier != 'free';

                      if (!currentIsVip) {
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
                        MaterialPageRoute(
                          builder: (context) => const BrandsPage(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.branding_watermark,
                            color: Colors.orange,
                            size: 28,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'برندها و مدل‌ها',
                            style: TextStyle(
                              fontFamily: 'Vazir',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      final currentUser = authService.currentUser;
                      final bool currentIsVip =
                          currentUser != null &&
                          currentUser.tier != null &&
                          currentUser.tier != 'free';

                      if (!currentIsVip) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'جستجوی پیشرفته نیازمند اشتراک VIP است.',
                              style: TextStyle(fontFamily: 'Vazir'),
                            ),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdvancedSearchPage(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.manage_search,
                            color: Colors.blue,
                            size: 28,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'جستجوی پیشرفته',
                            style: TextStyle(
                              fontFamily: 'Vazir',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
