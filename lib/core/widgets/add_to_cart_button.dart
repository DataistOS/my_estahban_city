// lib/common/widgets/add_to_cart_button.dart

import 'package:flutter/material.dart';
import 'package:my_estahban_city/services/cart_service.dart';

class AddToCartButton extends StatelessWidget {
  final String productId;

  const AddToCartButton({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final cartService = CartService();
        try {
          await cartService.addItemToCart(productId);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'محصول به سبد خرید اضافه شد.',
                  textDirection: TextDirection.rtl,
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
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
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF333333),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      icon: const Icon(Icons.add_shopping_cart, size: 18),
      label: const Text(
        'افزودن',
        style: TextStyle(fontFamily: 'Vazir', fontSize: 14),
      ),
    );
  }
}
