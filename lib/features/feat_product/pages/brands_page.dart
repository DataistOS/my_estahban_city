// lib/features/feat_product/pages/brands_page.dart

import 'package:flutter/material.dart';
import 'package:my_estahban_city/features/feat_product/models/product_model.dart';
import 'package:my_estahban_city/features/feat_product/pages/product_detail_page.dart';
import 'package:my_estahban_city/services/product_service.dart';
import 'package:my_estahban_city/core/widgets/add_to_cart_button.dart';
import 'package:my_estahban_city/core/widgets/cached_image_widget.dart';

class BrandsPage extends StatefulWidget {
  const BrandsPage({super.key});

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage>
    with SingleTickerProviderStateMixin {
  final ProductService _productService = ProductService();
  late TabController _tabController;
  late Future<List<String>> _brandsFuture;
  late Future<List<String>> _modelsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _brandsFuture = _productService.getAllBrands();
    _modelsFuture = _getAllModels();
  }

  Future<List<String>> _getAllModels() async {
    final products = await _productService.getAllProducts();
    final models = products
        .map((p) => p.model?.trim() ?? '')
        .where((m) => m.isNotEmpty)
        .toSet()
        .toList();
    models.sort((a, b) => a.compareTo(b));
    return models;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFDDE3F1),
        appBar: AppBar(
          title: const Text(
            'دسته‌بندی برندها و مدل‌ها',
            style: TextStyle(fontFamily: 'Vazir', fontSize: 18),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            labelStyle: const TextStyle(
              fontFamily: 'Vazir',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: 'Vazir',
              fontSize: 14,
            ),
            labelColor: const Color(0xFF333333),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.indigo,
            tabs: const [
              Tab(text: 'برندها'),
              Tab(text: 'مدل‌ها'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [_buildBrandsView(), _buildModelsView()],
        ),
      ),
    );
  }

  Widget _buildBrandsView() {
    return FutureBuilder<List<String>>(
      future: _brandsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'خطا: ${snapshot.error}',
              style: const TextStyle(fontFamily: 'Vazir'),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'هیچ برندی یافت نشد.',
              style: TextStyle(fontFamily: 'Vazir'),
            ),
          );
        }

        final brands = snapshot.data!;
        brands.sort((a, b) => a.compareTo(b));

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: brands.length,
          itemBuilder: (context, index) {
            final brand = brands[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BrandProductsPage(brandName: brand),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      radius: 22,
                      child: Icon(
                        Icons.branding_watermark,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      brand,
                      style: const TextStyle(
                        fontFamily: 'Vazir',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModelsView() {
    return FutureBuilder<List<String>>(
      future: _modelsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'خطا: ${snapshot.error}',
              style: const TextStyle(fontFamily: 'Vazir'),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'هیچ مدلی یافت نشد.',
              style: TextStyle(fontFamily: 'Vazir'),
            ),
          );
        }

        final models = snapshot.data!;
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: models.length,
          itemBuilder: (context, index) {
            final model = models[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModelProductsPage(modelName: model),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.indigo,
                      radius: 22,
                      child: Icon(Icons.layers, color: Colors.white, size: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      model,
                      style: const TextStyle(
                        fontFamily: 'Vazir',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class BrandProductsPage extends StatelessWidget {
  final String brandName;

  const BrandProductsPage({super.key, required this.brandName});

  @override
  Widget build(BuildContext context) {
    final ProductService productService = ProductService();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFDDE3F1),
        appBar: AppBar(
          title: Text(
            'محصولات برند $brandName',
            style: const TextStyle(fontFamily: 'Vazir', fontSize: 18),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder<List<ProductModel>>(
          future: productService.getProductsByBrand(brandName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'خطا: ${snapshot.error}',
                  style: const TextStyle(fontFamily: 'Vazir'),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'محصولی برای این برند یافت نشد.',
                  style: TextStyle(fontFamily: 'Vazir'),
                ),
              );
            }

            final products = snapshot.data!;
            final Map<String, List<ProductModel>> groupedByModel = {};
            for (var product in products) {
              final model = product.model?.trim().isNotEmpty == true
                  ? product.model!.trim()
                  : 'متفرقه';
              groupedByModel.putIfAbsent(model, () => []).add(product);
            }

            final sortedModels = groupedByModel.keys.toList()..sort();

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedModels.length,
              itemBuilder: (context, modelIndex) {
                final modelName = sortedModels[modelIndex];
                final modelProducts = groupedByModel[modelName]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'مدل: $modelName',
                            style: const TextStyle(
                              fontFamily: 'Vazir',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.indigo,
                            ),
                          ),
                          Text(
                            'تعداد: ${modelProducts.length} عدد',
                            style: const TextStyle(
                              fontFamily: 'Vazir',
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // لیست محصولات مربوط به این مدل
                    ...modelProducts.map((product) {
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
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
                                  CachedImageWidget(
                                    imageUrl: product.mainImage,
                                    height: 70,
                                    width: 70,
                                    borderRadius: BorderRadius.circular(8),
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
                                          fontSize: 15,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${product.price.toInt()} ت',
                                        style: const TextStyle(
                                          fontFamily: 'Vazir',
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AddToCartButton(productId: product.id),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ModelProductsPage extends StatelessWidget {
  final String modelName;

  const ModelProductsPage({super.key, required this.modelName});

  @override
  Widget build(BuildContext context) {
    final ProductService productService = ProductService();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFDDE3F1),
        appBar: AppBar(
          title: Text(
            'محصولات مدل $modelName',
            style: const TextStyle(fontFamily: 'Vazir', fontSize: 18),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder<List<ProductModel>>(
          future: productService.getAllProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'خطا: ${snapshot.error}',
                  style: const TextStyle(fontFamily: 'Vazir'),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'محصولی برای این مدل یافت نشد.',
                  style: TextStyle(fontFamily: 'Vazir'),
                ),
              );
            }

            final products = snapshot.data!
                .where((p) => p.model?.trim() == modelName)
                .toList();

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
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
                            CachedImageWidget(
                              imageUrl: product.mainImage,
                              height: 70,
                              width: 70,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontFamily: 'Vazir',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${product.price.toInt()} ت',
                                  style: const TextStyle(
                                    fontFamily: 'Vazir',
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AddToCartButton(productId: product.id),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
