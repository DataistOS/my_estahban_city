

// lib/core/widgets/product_card.dart

import 'package:flutter/material.dart';
import 'package:my_estahban_city/features/feat_product/pages/product_detail_page.dart';
import 'package:my_estahban_city/features/feat_product/models/product_model.dart';
import 'package:my_estahban_city/services/cart_service.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final CartService cartService = CartService();

  ProductCard({super.key, required this.product});

  String formatPrice(double price) {
    if (price == price.toInt()) {
      return price.toInt().toString();
    } else {
      return price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(product: product),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.mainImage.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    product.mainImage,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 8),
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
                'قیمت: ${formatPrice(product.price)} ت',
                style: const TextStyle(
                  fontFamily: 'Vazir',
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await cartService.addItemToCart(product.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'محصول به سبد خرید اضافه شد.',
                            textDirection: TextDirection.rtl,
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'خطا در افزودن محصول به سبد خرید.',
                            textDirection: TextDirection.rtl,
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF333333),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text(
                    'افزودن',
                    style: TextStyle(fontFamily: 'Vazir'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

