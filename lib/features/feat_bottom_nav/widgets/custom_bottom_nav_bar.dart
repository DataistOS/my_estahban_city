// lib/features/feat_bottom_nav/widgets/custom_bottom_nav_bar.dart

import 'package:flutter/material.dart';
import 'package:my_estahban_city/features/feat_auth/pages/profile_page.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Function(String? categoryId, String title) onCategorySelected;
  final VoidCallback? onCenterPressed;

  const CustomBottomNavBar({
    super.key,
    required this.onCategorySelected,
    this.onCenterPressed,
  });

  static const String showcaseId = '540rdjqsuhu8m2s';
  static const String gadgetld = 'muj88q8bix947wh';
  static const String supermarketId = 'o3910cys37qsdu4';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.category_outlined, color: Color(0xFF333333)),
            tooltip: 'دسته‌بندی‌ها',
            onPressed: () {
              _showCategoriesBottomSheet(context);
            },
          ),

          const SizedBox(width: 48),

          IconButton(
            icon: const Icon(Icons.person_outline, color: Color(0xFF333333)),
            tooltip: 'پروفایل من',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showCategoriesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'انتخاب دسته‌بندی محصولات',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.storefront, color: Colors.blue),
                  title: const Text(
                    'ویترین',
                    style: TextStyle(fontFamily: 'Vazir'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onCategorySelected(showcaseId, 'ویترین');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.devices, color: Colors.orange),
                  title: const Text(
                    'گجت',
                    style: TextStyle(fontFamily: 'Vazir'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onCategorySelected(gadgetld, 'گجت');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.shopping_basket,
                    color: Colors.green,
                  ),
                  title: const Text(
                    'سوپرمارکت',
                    style: TextStyle(fontFamily: 'Vazir'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onCategorySelected(supermarketId, 'سوپرمارکت');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
