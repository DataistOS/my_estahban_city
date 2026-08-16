// lib/features/feat_home/widgets/app_drawer.dart

import 'package:flutter/material.dart';

import 'package:my_estahban_city/features/feat_auth/pages/profile_page.dart';
import 'package:my_estahban_city/features/feat_orders/pages/order_history_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const UserAccountsDrawerHeader(
                  accountName: Text(' ', style: TextStyle(fontFamily: 'Vazir')),
                  accountEmail: Text(
                    '  ',
                    style: TextStyle(fontFamily: 'Vazir'),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text(
                    'پروفایل ‌من',
                    style: TextStyle(fontFamily: 'Vazir'),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text(
                    'تاریخچه خرید',
                    style: TextStyle(fontFamily: 'Vazir'),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const OrderHistoryPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add_shopping_cart),
                  title: const Text(
                    'درخواست محصول',
                    style: TextStyle(fontFamily: 'Vazir'),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/request-product');
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'آدرس: استهبان، جنب شرکت فرهنگیان',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'تلفن تماس: 09174565381',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'نسخه آزمایشی',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
