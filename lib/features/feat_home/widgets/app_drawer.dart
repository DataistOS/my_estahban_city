// lib/features/feat_home/widgets/app_drawer.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:my_estahban_city/features/feat_auth/pages/profile_page.dart';
import 'package:my_estahban_city/features/feat_orders/pages/order_history_page.dart';
import 'package:my_estahban_city/features/feat_about/pages/about_page.dart';
import 'package:my_estahban_city/services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  String _formatTier(String? tier) {
    switch (tier?.toLowerCase()) {
      case 'gold':
        return 'طلایی ⭐';
      case 'silver':
        return 'نقره‌ای 🥈';
      case 'bronze':
        return 'برنزی 🥉';
      default:
        return 'عادی';
    }
  }

  String _formatUserType(String? userType) {
    if (userType == 'legal') return 'حقوقی 🏢';
    if (userType == 'individual') return 'حقیقی 👤';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final String address = dotenv.env['SUPPORT_ADDRESS'] ?? 'آدرس ثبت نشده';
    final String phone = dotenv.env['SUPPORT_PHONE_NUMBER'] ?? 'تلفن ثبت نشده';
    final String appVersion = dotenv.env['APP_VERSION'] ?? 'نسخه آزمایشی';

    final primaryColor = Theme.of(context).primaryColor;
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;
    final bool isLoggedIn = user != null;

    String? avatarUrl;
    if (isLoggedIn && user.avatar.isNotEmpty) {
      final baseUrl =
          dotenv.env['POCKETBASE_URL'] ?? 'https://pocketbase.dataist.ir';
      avatarUrl = '$baseUrl/api/files/users/${user.id}/${user.avatar}';
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 48,
                bottom: 20,
                right: 20,
                left: 20,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withValues(alpha: 0.85)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          if (!isLoggedIn) {
                            Navigator.of(context).pushNamed('/login');
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.white,
                            backgroundImage: avatarUrl != null
                                ? NetworkImage(avatarUrl)
                                : null,
                            child: avatarUrl == null
                                ? Icon(
                                    Icons.person,
                                    size: 32,
                                    color: primaryColor,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      if (isLoggedIn)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Text(
                                _formatTier(user.tier),
                                style: const TextStyle(
                                  fontFamily: 'Vazir',
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (user.userType != null &&
                                user.userType!.isNotEmpty) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.4),
                                  ),
                                ),
                                child: Text(
                                  _formatUserType(user.userType),
                                  style: const TextStyle(
                                    fontFamily: 'Vazir',
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    isLoggedIn
                        ? (user.name.isNotEmpty ? user.name : 'شهروند استهبان')
                        : 'استهبان‌من',
                    style: const TextStyle(
                      fontFamily: 'Vazir',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'همراه هوشمند شهروندان',
                    style: TextStyle(
                      fontFamily: 'Vazir',
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),

            // لیست گزینه‌های منو
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.person_outline_rounded,
                    title: 'پروفایل ‌من',
                    onTap: () {
                      Navigator.of(context).pop();
                      if (!isLoggedIn) {
                        Navigator.of(context).pushNamed('/login');
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      }
                    },
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Divider(height: 1),
                  ),
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
                            fontSize: 11,
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
                          fontSize: 11,
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
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.transparent,
        hoverColor: Colors.grey.shade100,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Vazir',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }
}
