// lib/features/feat_search/pages/advanced_search_page.dart

import 'package:flutter/material.dart';
import 'package:my_estahban_city/features/feat_product/models/product_model.dart';
import 'package:my_estahban_city/features/feat_product/pages/product_detail_page.dart';
import 'package:my_estahban_city/core/widgets/cached_image_widget.dart';
import 'package:my_estahban_city/core/widgets/no_connection_widget.dart';
import 'package:my_estahban_city/core/errors/pocketbase_error_handler.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';
import 'package:my_estahban_city/features/feat_search/services/search_history_service.dart';

class AdvancedSearchPage extends StatefulWidget {
  static const String routeName = '/advanced-search';

  const AdvancedSearchPage({super.key});

  @override
  State<AdvancedSearchPage> createState() => _AdvancedSearchPageState();
}

class _AdvancedSearchPageState extends State<AdvancedSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final SearchHistoryService _searchHistoryService = SearchHistoryService();

  List<ProductModel> _searchResults = [];
  List<String> _availableBrands = [];
  bool _isLoading = false;
  Object? _pageError;

  // فیلترها
  String? _selectedBrand;
  final RangeValues _priceRange = const RangeValues(0, 100000000);
  bool _onlyAvailable = false;
  String _sortBy = 'newest';

  @override
  void initState() {
    super.initState();
    _fetchBrands();
    _performSearch();
  }

  void _showSnackBar(String message, {Color backgroundColor = Colors.black}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Vazir')),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Future<void> _fetchBrands() async {
    try {
      final records = await pocketBaseInstance
          .collection('products')
          .getFullList(fields: 'brand');
      final brands = records
          .map((r) => r.getStringValue('brand'))
          .where((b) => b.isNotEmpty)
          .toSet()
          .toList();

      if (mounted) {
        setState(() {
          _availableBrands = brands.cast<String>();
        });
      }
    } catch (e) {
      debugPrint('Error fetching brands: $e');
    }
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
      _pageError = null;
    });

    try {
      final query = _searchController.text.trim();
      List<String> filters = [];

      if (query.isNotEmpty) {
        filters.add(
          '(name ~ "$query" || description ~ "$query" || model ~ "$query")',
        );
        await _searchHistoryService.saveSearchQuery(query);
      }

      if (_selectedBrand != null && _selectedBrand!.isNotEmpty) {
        filters.add('brand = "$_selectedBrand"');
      }

      if (_onlyAvailable) {
        filters.add('is_available = true && stock > 0');
      }

      filters.add('price >= ${_priceRange.start}');
      filters.add('price <= ${_priceRange.end}');

      String sortString = '-created';
      if (_sortBy == 'price_asc') {
        sortString = 'price';
      } else if (_sortBy == 'price_desc') {
        sortString = '-price';
      }

      final records = await pocketBaseInstance
          .collection('products')
          .getList(
            filter: filters.isNotEmpty ? filters.join(' && ') : '',
            sort: sortString,
          );

      if (mounted) {
        setState(() {
          _searchResults = records.items
              .map((r) => ProductModel.fromRecord(r))
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      final errorStr = e.toString();
      if (mounted) {
        setState(() {
          _isLoading = false;
          // بررسی قطع اینترنت
          if (errorStr.contains('SocketException') ||
              errorStr.contains('statusCode: 0') ||
              errorStr.contains('Failed host lookup')) {
            _pageError = e;
          } else {
            _showSnackBar(
              getFriendlyErrorMessage(e),
              backgroundColor: Colors.red,
            );
          }
        });
      }
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'فیلترهای پیشرفته',
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'برند محصول',
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton<String?>(
                        value: _selectedBrand,
                        isExpanded: true,
                        hint: const Text(
                          'همه برندها',
                          style: TextStyle(fontFamily: 'Vazir'),
                        ),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text(
                              'همه برندها',
                              style: TextStyle(fontFamily: 'Vazir'),
                            ),
                          ),
                          ..._availableBrands.map((brand) {
                            return DropdownMenuItem<String?>(
                              value: brand,
                              child: Text(
                                brand,
                                style: const TextStyle(fontFamily: 'Vazir'),
                              ),
                            );
                          }),
                        ],
                        onChanged: (val) {
                          setModalState(() {
                            _selectedBrand = val;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      SwitchListTile(
                        title: const Text(
                          'فقط کالاهای موجود',
                          style: TextStyle(fontFamily: 'Vazir'),
                        ),
                        value: _onlyAvailable,
                        onChanged: (val) {
                          setModalState(() {
                            _onlyAvailable = val;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'مرتب‌سازی بر اساس',
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton<String>(
                        value: _sortBy,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: 'newest',
                            child: Text(
                              'جدیدترین',
                              style: TextStyle(fontFamily: 'Vazir'),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'price_asc',
                            child: Text(
                              'ارزان‌ترین',
                              style: TextStyle(fontFamily: 'Vazir'),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'price_desc',
                            child: Text(
                              'گران‌ترین',
                              style: TextStyle(fontFamily: 'Vazir'),
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              _sortBy = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _performSearch();
                          },
                          child: const Text(
                            'اعمال فیلترها',
                            style: TextStyle(
                              fontFamily: 'Vazir',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFDDE3F1),
        appBar: AppBar(
          title: const Text(
            'جستجوی پیشرفته',
            style: TextStyle(fontFamily: 'Vazir', fontSize: 18),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: _pageError != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(child: NoConnectionWidget()),
                      ElevatedButton(
                        onPressed: _performSearch,
                        child: const Text(
                          'تلاش مجدد',
                          style: TextStyle(fontFamily: 'Vazir'),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => _performSearch(),
                            decoration: InputDecoration(
                              labelText: 'جستجو در نام، مدل، توضیحات...',
                              labelStyle: const TextStyle(
                                fontFamily: 'Vazir',
                                fontSize: 13,
                              ),
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(12),
                          ),
                          icon: const Icon(
                            Icons.filter_list,
                            color: Colors.blue,
                          ),
                          onPressed: _showFilterBottomSheet,
                        ),
                      ],
                    ),
                  ),

                  // لیست نتایج
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _searchResults.isEmpty
                        ? const Center(
                            child: Text(
                              'محصولی با این مشخصات یافت نشد.',
                              style: TextStyle(
                                fontFamily: 'Vazir',
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final product = _searchResults[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(8),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: CachedImageWidget(
                                        imageUrl: product.mainImage,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontFamily: 'Vazir',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (product.brand != null &&
                                          product.brand!.isNotEmpty)
                                        Text(
                                          'برند: ${product.brand}',
                                          style: const TextStyle(
                                            fontFamily: 'Vazir',
                                            fontSize: 12,
                                          ),
                                        ),
                                      Text(
                                        '${product.price.toStringAsFixed(0)} تومان',
                                        style: const TextStyle(
                                          fontFamily: 'Vazir',
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailPage(product: product),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
