// lib/features/feat_product/pages/brands_page.dart

import 'package:flutter/material.dart';
import 'package:my_estahban_city/features/feat_product/models/product_model.dart';
import 'package:my_estahban_city/features/feat_product/pages/product_detail_page.dart';
import 'package:my_estahban_city/services/product_service.dart';
import 'package:my_estahban_city/core/widgets/add_to_cart_button.dart';

class BrandsPage extends StatefulWidget {
  const BrandsPage({super.key});

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  final ProductService _productService = ProductService();
  late Future<List<String>> _brandsFuture;

  @override
  void initState() {
    super.initState();
    _brandsFuture = _productService.getAllBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFDDE3F1),
        appBar: AppBar(
          title: const Text(
            'برندها و مدل محصولات',
            style: TextStyle(fontFamily: 'Vazir', fontSize: 18),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder<List<String>>(
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
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(
                        Icons.branding_watermark,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      brand,
                      style: const TextStyle(
                        fontFamily: 'Vazir',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: const Text(
                      'مشاهده مدل‌ها و محصولات این برند',
                      style: TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BrandProductsPage(brandName: brand),
                        ),
                      );
                    },
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
              String modelName =
                  (product.model != null && product.model!.trim().isNotEmpty)
                  ? product.model!.trim()
                  : 'سایر مدل‌ها / متفرقه';

              if (!groupedByModel.containsKey(modelName)) {
                groupedByModel[modelName] = [];
              }
              groupedByModel[modelName]!.add(product);
            }

            final models = groupedByModel.keys.toList();

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: models.length,
              itemBuilder: (context, modelIndex) {
                final modelName = models[modelIndex];
                final modelProducts = groupedByModel[modelName]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 4.0,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.layers,
                            size: 18,
                            color: Colors.indigo,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'مدل: $modelName',
                            style: const TextStyle(
                              fontFamily: 'Vazir',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.indigo.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${modelProducts.length} محصول',
                              style: const TextStyle(
                                fontFamily: 'Vazir',
                                fontSize: 11,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

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
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      product.mainImage,
                                      height: 70,
                                      width: 70,
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
                    const SizedBox(height: 12),
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
