// lib/features/feat_product/pages/full_screen_image_page.dart

import 'package:flutter/material.dart';

class FullScreenImagePage extends StatefulWidget {
  final List<String> images;
  final String heroTag;
  final int initialIndex;

  const FullScreenImagePage({
    super.key,
    required this.images,
    required this.heroTag,
    this.initialIndex = 0,
  });

  @override
  State<FullScreenImagePage> createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      // **حذف GestureDetector خارجی برای رفع تداخل با swipe**
      body: Stack(
        children: [
          // ویجت اصلی: PageView برای اسلاید
          // اکنون PageView کنترل ژست‌ها را در دست می‌گیرد.
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final imageUrl = widget.images[index];
              final isInitialImage = index == widget.initialIndex;

              final imageWidget = Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error, color: Colors.white),
              );

              // Hero فقط برای عکسی که در ابتدا باز می‌شود
              if (isInitialImage) {
                return Hero(
                  tag: widget.heroTag, // استفاده از همان تگ ارسالی
                  child: imageWidget,
                );
              }
              return imageWidget;
            },
          ),

          // نشانگرها (Indicators) در پایین صفحه
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (index) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}