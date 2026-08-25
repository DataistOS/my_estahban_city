// lib/features/feat_home/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import 'package:my_estahban_city/features/feat_cart/pages/cart_page.dart';
import 'package:my_estahban_city/features/feat_product/models/product_model.dart';
import 'package:my_estahban_city/features/feat_product/pages/product_detail_page.dart';

import 'package:my_estahban_city/core/widgets/add_to_cart_button.dart';
import 'package:my_estahban_city/services/product_service.dart';
import 'package:my_estahban_city/services/auth_service.dart';
import 'package:my_estahban_city/core/widgets/search_widget.dart';

import 'package:my_estahban_city/features/feat_home/widgets/app_drawer.dart';
import 'package:my_estahban_city/features/feat_scanner/pages/product_scanner_page.dart';
import 'package:my_estahban_city/features/feat_bottom_nav/widgets/custom_bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductService productService = ProductService();
  late Future<List<ProductModel>> _productsFuture;

  String _searchText = '';

  String? _selectedCategoryId = '540rdjqsuhu8m2s';
  String _currentTitle = 'استهبان‌من (ویترین)';

  final List<String> bannerImages = [
    'assets/images/bannerImages1.jpg',
    'assets/images/bannerImages2.jpg',
    'assets/images/bannerImages3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    bool isFreeUser = user == null || user.tier == null || user.tier == 'free';

    setState(() {
      if (isFreeUser) {
        _selectedCategoryId = '540rdjqsuhu8m2s';
        _currentTitle = 'استهبان‌من (ویترین)';
        _productsFuture = productService.getShowcaseProducts('540rdjqsuhu8m2s');
      } else if (_selectedCategoryId != null) {
        _productsFuture = productService.getShowcaseProducts(
          _selectedCategoryId!,
        );
      } else {
        _productsFuture = productService.getAllProducts();
      }
    });
  }

  void _onCategorySelected(String? categoryId, String title) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    bool isVip = user != null && user.tier != null && user.tier != 'free';

    if (!isVip && categoryId != '540rdjqsuhu8m2s') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'برای مشاهده این دسته‌بندی، لطفا اشتراک VIP تهیه کنید.',
            style: TextStyle(fontFamily: 'Vazir'),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _selectedCategoryId = categoryId;
      _currentTitle = 'استهبان‌من ($title)';
    });
    _loadProducts();
  }

  void _updateSearchText(String newText) {
    setState(() {
      _searchText = newText;
    });
  }

  void _navigateToScanner() {
    Navigator.of(context).pushNamed(ProductScannerPage.routeName);
  }

  void _showCenterMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ابزارهای سریع',
                  style: TextStyle(
                    fontFamily: 'Vazir',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.blue,
                  ),
                  title: const Text(
                    'اسکن بارکد',
                    style: TextStyle(fontFamily: 'Vazir'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToScanner();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.flash_on, color: Colors.orange),
                  title: const Text(
                    'سایر امکانات سریع',
                    style: TextStyle(fontFamily: 'Vazir'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
          title: Text(
            _currentTitle,
            style: const TextStyle(
              fontFamily: 'Vazir',
              color: Color(0xFF333333),
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
              icon: const Icon(Icons.shopping_cart, color: Color(0xFF333333)),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 200.0,
                child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    aspectRatio: 16 / 9,
                  ),
                  items: bannerImages.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage(item),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),

              if (!isVip && _selectedCategoryId == '540rdjqsuhu8m2s')
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade400),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'شما در حال مشاهده ویترین هستید. برای دسترسی به تمامی خدمات و تخفیف‌های ویژه، اشتراک VIP تهیه کنید.',
                          style: TextStyle(fontFamily: 'Vazir', fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

              SearchWidget(
                onSearch: _updateSearchText,
                onScanPressed: _navigateToScanner,
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<ProductModel>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('خطا: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('هیچ محصولی در این دسته‌بندی پیدا نشد.'),
                    );
                  } else {
                    final products = snapshot.data!;
                    final filteredProducts = products.where((product) {
                      final nameLower = product.name.toLowerCase();
                      final searchTextLower = _searchText.toLowerCase();
                      return nameLower.contains(searchTextLower);
                    }).toList();

                    if (filteredProducts.isEmpty) {
                      return const Center(child: Text('نتیجه‌ای یافت نشد.'));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailPage(product: product),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  if (product.mainImage.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        product.mainImage,
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontFamily: 'Vazir',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'قیمت: ${product.price.toInt()} ت',
                                          style: const TextStyle(
                                            fontFamily: 'Vazir',
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  AddToCartButton(productId: product.id),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCenterMenu(context),
          backgroundColor: Colors.blueAccent,
          elevation: 4,
          child: const Icon(
            Icons.qr_code_scanner,
            color: Colors.white,
            size: 28,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomBottomNavBar(
          onCategorySelected: _onCategorySelected,
        ),
      ),
    );
  }
}
