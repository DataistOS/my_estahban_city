// lib/features/feat_home/widgets/app_drawer.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:my_estahban_city/features/feat_auth/pages/profile_page.dart';
import 'package:my_estahban_city/features/feat_orders/pages/order_history_page.dart';
import 'package:my_estahban_city/features/feat_about/pages/about_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final String address = dotenv.env['SUPPORT_ADDRESS'] ?? 'آدرس ثبت نشده';
    final String phone = dotenv.env['SUPPORT_PHONE_NUMBER'] ?? 'تلفن ثبت نشده';
    final String appVersion = dotenv.env['APP_VERSION'] ?? 'نسخه آزمایشی';

    final primaryColor = Theme.of(context).primaryColor;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: primaryColor),
            accountName: const Text(
              'استهبان‌من',
              style: TextStyle(
                fontFamily: 'Vazir',
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: const Text(
              'همراه هوشمند شهروندان',
              style: TextStyle(fontFamily: 'Vazir', fontSize: 12),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 36, color: primaryColor),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.person_outline_rounded,
                  title: 'پروفایل ‌من',
                  onTap: () => _navigateTo(context, const ProfilePage()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.history_rounded,
                  title: 'تاریخچه خرید',
                  onTap: () => _navigateTo(context, const OrderHistoryPage()),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.add_shopping_cart_rounded,
                  title: 'درخواست محصول',
                  onTap: () =>
                      Navigator.of(context).pushNamed('/request-product'),
                ),
                const Divider(indent: 16, endIndent: 16, height: 24),
                _buildDrawerItem(
                  context,
                  icon: Icons.info_outline_rounded,
                  title: 'درباره ما',
                  onTap: () => _navigateTo(context, const AboutPage()),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            color: Colors.grey.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        address,
                        style: const TextStyle(
                          fontFamily: 'Vazir',
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.phone_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'تلفن: $phone',
                      style: const TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 16),
                Center(
                  child: Text(
                    appVersion,
                    style: TextStyle(
                      fontFamily: 'Vazir',
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        title,
        style: const TextStyle(fontFamily: 'Vazir', fontSize: 14),
      ),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }
}
