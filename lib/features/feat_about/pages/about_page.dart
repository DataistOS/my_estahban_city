// lib/features/feat_about/pages/about_page.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $urlString');
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
            'درباره ما',
            style: TextStyle(
              fontFamily: 'Vazir',
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF333333)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                title: 'شرکت آزاداندیش داده‌ساز',
                children: [
                  const Text(
                    'درباره ما',
                    style: TextStyle(
                      fontFamily: 'Vazir',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1A365D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'ما به عنوان یکی از پیشگامان در ارائه راهکارهای نوآورانه فناوری اطلاعات، به ارتقاء تجربه کاربری و بهره‌وری کسب و کارها می‌پردازیم.',
                    style: TextStyle(
                      fontFamily: 'Vazir',
                      fontSize: 14,
                      height: 1.6,
                      color: Color(0xFF4A5568),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                title: 'خدمات و محدوده وظایف',
                children: [
                  _buildBulletItem('سرویس‌دهی به سامانه‌‌های شهروندی'),
                  _buildBulletItem('توسعه و مشارکت در سیستم‌عامل دیتائیست'),
                  _buildBulletItem(
                    'حمایت مادی و معنوی از گروه‌های کاربری گنو/لینوکس (NGO)',
                  ),
                  _buildBulletItem('لاگ استهبان'),
                  _buildBulletItem(
                    'در دسترس قرار دادن ابزار‌های توسعه و زیرساختی',
                  ),
                  _buildBulletItem(
                    'فرهنگ‌سازی در زمینه اندیشه دیتائیسم (داده‌گرایی)',
                  ),
                  _buildBulletItem('داده‌کاوی و تحلیل رفتار مشتری'),
                  _buildBulletItem('تحلیل انواع کسب و کار'),
                  _buildBulletItem('امنیت شبکه، تست و نفوذ'),
                  _buildBulletItem(
                    'مشاوره و نظارت بر اجرای طرح‌های انفورماتیکی',
                  ),
                  _buildBulletItem('بهینه‌سازی مشاغل با هوش مصنوعی'),
                  _buildBulletItem('طراحی وبسایت و اپلیکیشن موبایل'),
                  _buildBulletItem('طراحی سرویس‌های نرم‌افزاری'),
                  _buildBulletItem('طراحی و توسعه بازی‌های رایانه‌ای'),
                  _buildBulletItem('تولید و پشتیبانی بسته‌های نرم‌افزاری'),
                  _buildBulletItem('تولید و ارائه دستگاه‌های جانبی'),
                  _buildBulletItem('توسعه و زیرساخت خانه‌های هوشمند'),
                  _buildBulletItem(
                    'طراحی و پیاده‌سازی زیرساخت‌های مرتبط با کشاورزی و باغبانی',
                  ),
                  _buildBulletItem(
                    'اجرا، پشتیبانی، خرید و فروش کلیه‌ی تجهیزات رایانه‌ای و موبایل',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                title: 'پیوند به خدمات',
                children: [
                  _buildLinkCategory('EstahbanLug.ir', [
                    'https://t.me/EstahbanLug',
                    'https://x.com/EstahbanLug',
                    'https://instagram.com/estahban_lug',
                    'https://next.dataist.ir/u/estahbanlug',
                    'https://next.dataist.ir/call/63fpsv8u',
                  ]),
                  _buildLinkCategory('Dataist.ir', [
                    'https://dataist.ir',
                    'https://idna.dataist.ir',
                    'https://dpic.dataist.ir',
                    'https://donate.dataist.ir',
                    'https://t.me/DataistLinux',
                    'https://github.com/DataistOS',
                    'https://instagram.com/dataist_ir',
                    'https://next.dataist.ir/u/dataist',
                    'https://status.dataist.ir/status/heuristic',
                    'https://distrowatch.com/table.php?distribution=dataist',
                  ]),
                  _buildLinkCategory('Estahban.city', [
                    'https://estahban.city',
                    'https://t.me/www_estahban_city',
                    'https://instagram.com/eatahban_city',
                    'https://next.dataist.ir/call/6ngrruh7',
                  ]),
                  _buildLinkCategory('My.Estahban.city', [
                    'https://my.estahban.city',
                    'https://t.me/my_estahban_city',
                    'https://t.me/EstahbanShop',
                    'https://instagram.com/my_estahban_city',
                    'https://instagram.com/EstahbanShop',
                  ]),
                  _buildLinkCategory('FTDC', [
                    'https://next.dataist.ir/u/ftdc',
                  ]),
                  _buildLinkCategory('Dataism.art', [
                    'https://t.me/dataism_art',
                    'https://next.dataist.ir/u/dataism',
                  ]),
                  _buildLinkCategory('Garden.city', [
                    'https://t.me/www_Garden_city',
                  ]),
                  const SizedBox(height: 8),
                  const Text(
                    '• fbsc_estahban_city',
                    style: TextStyle(
                      fontFamily: 'Vazir',
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '• MyEstahban | فروشگاه تجربه‌محور استهبان‌من',
                    style: TextStyle(
                      fontFamily: 'Vazir',
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '• Next.Dataist.ir | راهکار نکس',
                    style: TextStyle(
                      fontFamily: 'Vazir',
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Vazir',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const Divider(height: 20, thickness: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Vazir',
                fontSize: 13,
                color: Color(0xFF4A5568),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkCategory(String categoryName, List<String> links) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '# $categoryName',
            style: const TextStyle(
              fontFamily: 'Vazir',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 4),
          ...links.map(
            (link) => Padding(
              padding: const EdgeInsets.only(right: 12.0, bottom: 4.0),
              child: InkWell(
                onTap: () => _launchUrl(link),
                child: Text(
                  link,
                  style: const TextStyle(
                    fontFamily: 'Vazir',
                    fontSize: 12,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
