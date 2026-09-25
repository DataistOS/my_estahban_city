// lib/features/feat_home/widgets/home_product_list.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:my_estahban_city/features/feat_product/models/product_model.dart';
import 'package:my_estahban_city/features/feat_product/pages/product_detail_page.dart';
import 'package:my_estahban_city/core/widgets/add_to_cart_button.dart';
import 'package:my_estahban_city/core/widgets/cached_image_widget.dart';

class HomeProductList extends StatelessWidget {
  final Future<List<ProductModel>> productsFuture;
  final String searchText;

  const HomeProductList({
    super.key,
    required this.productsFuture,
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 14,
                                width: double.infinity,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 12,
                                width: 80,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 36,
                          width: 36,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'خطا: ${snapshot.error}',
              style: const TextStyle(fontFamily: 'Vazir'),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'هیچ محصولی در این دسته‌بندی پیدا نشد.',
                style: TextStyle(fontFamily: 'Vazir'),
              ),
            ),
          );
        } else {
          final products = snapshot.data!;
          final filteredProducts = products.where((product) {
            final nameLower = product.name.toLowerCase();
            final searchTextLower = searchText.toLowerCase();
            return nameLower.contains(searchTextLower);
          }).toList();

          if (filteredProducts.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'نتیجه‌ای یافت نشد.',
                  style: TextStyle(fontFamily: 'Vazir'),
                ),
              ),
            );
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
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          CachedImageWidget(
                            imageUrl: product.mainImage,
                            height: 80,
                            width: 80,
                            borderRadius: BorderRadius.circular(8.0),
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
                                  fontSize: 14,
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
    );
  }
}
