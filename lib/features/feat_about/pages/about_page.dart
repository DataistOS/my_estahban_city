// lib/features/feat_about/pages/about_us_page.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $urlString');
    }
  }

  String _getAssetLogoForUrl(String url) {
    if (url.contains('status.dataist.ir')) {
      return 'assets/images/uptimekuma_logo.png';
    } else if (url.contains('next.dataist.ir')) {
      return 'assets/images/nextcloud_logo.png';
    } else if (url.contains('t.me')) {
      return 'assets/images/logo_telegram.png';
    } else if (url.contains('instagram.com')) {
      return 'assets/images/logo_Instagram.png';
    } else if (url.contains('x.com') || url.contains('twitter.com')) {
      return 'assets/images/logo_x.png';
    } else if (url.contains('github.com')) {
      return 'assets/images/logo_github.png';
    } else if (url.contains('distrowatch.com')) {
      return 'assets/images/logo.png';
    } else {
      return 'assets/images/logo_website.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final enamadUrl = dotenv.env['ENAMAD_URL'] ?? 'https://trustseal.enamad.ir';
    final enamadLogoUrl = dotenv.env['ENAMAD_LOGO_URL'] ?? '';

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
                    'سامانه جامع شهروندی "استهبان‌من" با هدف تسهیل و ارتقای خدمات‌رسانی به شهروندان گرامی استهبان طراحی و توسعه یافته است. این اپلیکیشن پلتفرمی هوشمند و یکپارچه در اکوسیستم دیتائیست است که دسترسی راحت، سریع و شفاف به انواع خدمات شهری، اطلاع‌رسانی‌ها و زیرساخت‌های کاربردی را برای هم‌شهریان عزیز فراهم می‌سازد',
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
                  _buildBulletItem('سرویس‌دهی به سامانه‌های شهروندی'),
                  _buildBulletItem('توسعه و مشارکت در سیستم‌عامل دیتائیست'),
                  _buildBulletItem(
                    'حمایت مادی و معنوی از گروه‌های کاربری گنو/لینوکس (NGO)',
                  ),
                  _buildBulletItem('گروه کاربران لینوکس استهبان'),
                  _buildBulletItem(
                    'در دسترس قرار دادن ابزارهای توسعه و زیرساختی',
                  ),
                  _buildBulletItem(
                    'فرهنگ‌سازی در زمینه اندیشه دیتائیسم (داده‌گرایی)',
                  ),
                  _buildBulletItem('داده‌کاوی و تحلیل رفتار مشتری'),
                  _buildBulletItem('تحلیل انواع کسب‌وکار'),
                  _buildBulletItem('امنیت شبکه، تست و نفوذ'),
                  _buildBulletItem(
                    'مشاوره و نظارت بر اجرای طرح‌های انفورماتیکی',
                  ),
                  _buildBulletItem('بهینه‌سازی مشاغل با هوش مصنوعی'),
                  _buildBulletItem('طراحی وب‌سایت و اپلیکیشن موبایل'),
                  _buildBulletItem('طراحی سرویس‌های نرم‌افزاری'),
                  _buildBulletItem('طراحی و توسعه بازی‌های رایانه‌ای'),
                  _buildBulletItem('تولید و پشتیبانی بسته‌های نرم‌افزاری'),
                  _buildBulletItem('تولید و ارائه دستگاه‌های جانبی'),
                  _buildBulletItem('توسعه و زیرساخت خانه‌های هوشمند'),
                  _buildBulletItem(
                    'طراحی و پیاده‌سازی زیرساخت‌های مرتبط با کشاورزی و باغبانی',
                  ),
                  _buildBulletItem(
                    'اجرا، پشتیبانی، خرید و فروش کلیه تجهیزات رایانه‌ای و موبایل',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildSectionCard(
                title: 'پیوند به خدمات',
                children: [
                  _buildLinkCategory('⭐ سرویس‌های پرکاربرد', [
                    const LinkItem('دیوار استهبان', 'https://estahban.city'),
                    const LinkItem('مستندات', 'https://dpic.dataist.ir'),
                    const LinkItem('توانمندسازی', 'https://t.me/EstahbanLug'),
                    const LinkItem(
                      'وضعیت',
                      'https://status.dataist.ir/status/heuristic',
                    ),
                    const LinkItem('ثبت‌نام', 'https://idna.dataist.ir'),
                    const LinkItem('استهبان‌من', 'https://my.estahban.city'),
                  ], isFeatured: true),
                  const Divider(height: 28, thickness: 1),

                  _buildLinkCategory(
                    'EstahbanLug.ir | گروه کاربران گنو لینوکس استهبان',
                    [
                      const LinkItem('تلگرام', 'https://t.me/EstahbanLug'),
                      const LinkItem('اکس', 'https://x.com/EstahbanLug'),
                      const LinkItem(
                        'اینستاگرام',
                        'https://instagram.com/estahban_lug',
                      ),
                      const LinkItem(
                        'پروفایل نکس',
                        'https://next.dataist.ir/u/estahbanlug',
                      ),
                      const LinkItem(
                        'گروه نکس',
                        'https://next.dataist.ir/call/63fpsv8u',
                      ),
                    ],
                  ),
                  _buildLinkCategory('Dataist.ir | سیستم‌عامل دیتائیست', [
                    const LinkItem('وب‌سایت', 'https://dataist.ir'),
                    const LinkItem('احراز هویت', 'https://idna.dataist.ir'),
                    const LinkItem('مستندات', 'https://dpic.dataist.ir'),
                    const LinkItem('حمایت مالی', 'https://donate.dataist.ir'),
                    const LinkItem('تلگرام', 'https://t.me/DataistLinux'),
                    const LinkItem('گیت‌هاب', 'https://github.com/DataistOS'),
                    const LinkItem(
                      'اینستاگرام',
                      'https://instagram.com/dataist_ir',
                    ),
                    const LinkItem(
                      'پروفایل',
                      'https://next.dataist.ir/u/dataist',
                    ),
                    const LinkItem(
                      'وضعیت سرویس',
                      'https://status.dataist.ir/status/heuristic',
                    ),
                    const LinkItem(
                      'دیسترواچ',
                      'https://distrowatch.com/table.php?distribution=dataist',
                    ),
                  ]),
                  _buildLinkCategory('Estahban.city | دیوار استهبان', [
                    const LinkItem('وب‌سایت', 'https://estahban.city'),
                    const LinkItem('تلگرام', 'https://t.me/www_estahban_city'),
                    const LinkItem(
                      'اینستاگرام',
                      'https://instagram.com/eatahban_city',
                    ),
                    const LinkItem(
                      'کانال نکس',
                      'https://next.dataist.ir/call/6ngrruh7',
                    ),
                  ]),
                  _buildLinkCategory(
                    'My.Estahban.city | اپلیکیشن شهروندی استهبان‌من',
                    [
                      const LinkItem('استهبان‌من', 'https://my.estahban.city'),
                      const LinkItem('تلگرام', 'https://t.me/my_estahban_city'),
                      const LinkItem('فروشگاه', 'https://t.me/EstahbanShop'),
                      const LinkItem(
                        'اینستاگرام',
                        'https://instagram.com/my_estahban_city',
                      ),
                      const LinkItem(
                        'اینستاگرام',
                        'https://instagram.com/EstahbanShop',
                      ),
                    ],
                  ),
                  _buildLinkCategory('FTDC | شرکت آزاداندیش داده‌ساز', [
                    const LinkItem('پروفایل', 'https://next.dataist.ir/u/ftdc'),
                  ]),
                  _buildLinkCategory('Dataism.art | نمایشگاه هنر داده‌گرایی', [
                    const LinkItem('تلگرام', 'https://t.me/dataism_art'),
                    const LinkItem(
                      'پروفایل',
                      'https://next.dataist.ir/u/dataism',
                    ),
                  ]),
                  _buildLinkCategory('Garden.city | شرکت باغبانی', [
                    const LinkItem('تلگرام', 'https://t.me/www_Garden_city'),
                  ]),
                  _buildLinkCategory('FBSC.Estahban.city | انبار و لجستیک', [
                    const LinkItem('وب‌سایت', 'https://fbsc.estahban.city'),
                  ]),
                  _buildLinkCategory(
                    'MyEstahban | فروشگاه تجربه‌محور استهبان‌من',
                    [const LinkItem('فروشگاه', 'https://my.estahban.city')],
                  ),
                  _buildLinkCategory('Next.Dataist.ir | راهکار سازمانی', [
                    const LinkItem('وب‌سایت', 'https://next.dataist.ir'),
                  ]),
                ],
              ),
              const SizedBox(height: 20),
              if (enamadLogoUrl.isNotEmpty)
                Center(
                  child: InkWell(
                    onTap: () => _launchUrl(enamadUrl),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Image.network(
                        enamadLogoUrl,
                        width: 120,
                        errorBuilder: (context, error, stackTrace) =>
                            const Text(
                              'تصویر اینماد',
                              style: TextStyle(color: Colors.grey),
                            ),
                      ),
                    ),
                  ),
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
            color: Colors.black.withValues(alpha: 0.05),
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

  Widget _buildLinkCategory(
    String categoryName,
    List<LinkItem> items, {
    bool isFeatured = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoryName,
            style: TextStyle(
              fontFamily: 'Vazir',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isFeatured ? const Color(0xFFD69E2E) : Colors.indigo,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: items.map((item) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _launchUrl(item.url),
                  borderRadius: BorderRadius.circular(10),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isFeatured
                          ? const Color(0xFFFEFCBF).withValues(alpha: 0.3)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isFeatured
                            ? const Color(0xFFECC94B)
                            : const Color(0xFFE2E8F0),
                        width: isFeatured ? 1.2 : 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          _getAssetLogoForUrl(item.url),
                          width: 22,
                          height: 22,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.link,
                                size: 22,
                                color: Colors.blue,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.title,
                          style: TextStyle(
                            fontFamily: 'Vazir',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isFeatured
                                ? const Color(0xFF744210)
                                : const Color(0xFF2B6CB0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class LinkItem {
  final String title;
  final String url;

  const LinkItem(this.title, this.url);
}
