// lib/features/feat_auth/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFDDE3F1),
        appBar: AppBar(
          title: const Text(
            'پروفایل کاربری',
            style: TextStyle(fontFamily: 'Vazir', color: Color(0xFF333333)),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'شما وارد حساب کاربری نشده‌اید.',
                style: TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 18,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF333333),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'ورود / ثبت‌نام',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final formattedDateCreated = DateFormat('yyyy/MM/dd').format(user.created);
    final formattedDateUpdated = DateFormat('yyyy/MM/dd').format(user.updated);

    return Scaffold(
      backgroundColor: const Color(0xFFDDE3F1),
      appBar: AppBar(
        title: const Text(
          'پروفایل کاربری',
          style: TextStyle(fontFamily: 'Vazir', color: Color(0xFF333333)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(context, user.name ?? 'شهروند استهبان‌'),

            const SizedBox(height: 16),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildInfoTile(context, Icons.email, 'ایمیل', user.email),
                    _buildInfoTile(
                      context,
                      Icons.phone,
                      'شماره تلفن',
                      user.phoneNumber ?? 'وارد نشده',
                    ),
                    _buildInfoTile(
                      context,
                      Icons.location_on,
                      'آدرس',
                      user.address ?? 'وارد نشده',
                    ),
                    _buildInfoTile(
                      context,
                      Icons.person_pin,
                      'نوع کاربر',
                      user.userType ?? 'نامشخص',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildInfoTile(
                      context,
                      Icons.date_range,
                      'تاریخ ثبت‌نام',
                      formattedDateCreated,
                    ),
                    _buildInfoTile(
                      context,
                      Icons.update,
                      'تاریخ آخرین به‌روزرسانی',
                      formattedDateUpdated,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () async {
                await authService.logout();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: const Icon(Icons.logout, size: 20),
              label: const Text(
                'خروج از حساب کاربری',
                style: TextStyle(fontFamily: 'Vazir', fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String name) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFF333333),
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              fontFamily: 'Vazir',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF333333)),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Vazir',
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Color(0xFF333333),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: 'Vazir',
          fontSize: 14,
          color: Color(0xFF666666),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
    );
  }
}
