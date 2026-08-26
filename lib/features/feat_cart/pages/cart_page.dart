// lib/features/feat_product/cart_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // اضافه شده برای خواندن متغیرها
import 'package:my_estahban_city/features/feat_cart/models/cart_model.dart';
import 'package:my_estahban_city/features/feat_product/models/product_model.dart';
import 'package:my_estahban_city/services/cart_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService cartService = CartService();
  late Future<CartModel?> _cartFuture;

  @override
  void initState() {
    super.initState();
    _cartFuture = cartService.getCartWithProducts();
  }

  void _refreshCart() {
    setState(() {
      _cartFuture = cartService.getCartWithProducts();
    });
  }

  Future<void> _incrementQuantity(CartItemModel item) async {
    await cartService.updateItemQuantity(item.productId, item.quantity + 1);
    _refreshCart();
  }

  Future<void> _decrementQuantity(CartItemModel item) async {
    await cartService.updateItemQuantity(item.productId, item.quantity - 1);
    _refreshCart();
  }

  Future<void> _handleCheckout(double totalAmount) async {
    try {
      await cartService.checkout(totalAmount, {
        'city': 'Estahban',
        'street': 'Main Street',
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'سفارش شما با موفقیت ثبت شد!',
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: Colors.green,
        ),
      );
      _refreshCart();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('خطا در ثبت سفارش.', textDirection: TextDirection.rtl),
          backgroundColor: Colors.red,
        ),
      );
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
            'سبد خرید',
            style: TextStyle(fontFamily: 'Vazir', color: Color(0xFF333333)),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder<CartModel?>(
          future: _cartFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('خطا: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
              return const Center(child: Text('سبد خرید شما خالی است.'));
            } else {
              final cart = snapshot.data!;
              double totalAmount = 0.0;
              for (var item in cart.items) {
                if (item.product != null) {
                  totalAmount += item.product!.price * item.quantity;
                }
              }

              return Column(
                children: [
                  _buildPaymentInfoBanner(context),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        final product = item.product;

                        if (product == null) {
                          return const SizedBox();
                        }

                        return _buildCartItemCard(item, product, context);
                      },
                    ),
                  ),
                  _buildCheckoutSection(totalAmount, context),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildPaymentInfoBanner(BuildContext context) {
    final cardNumber =
        dotenv.env['SUPPORT_CARD_NUMBER'] ?? '۶۱۰۴-۳۳۷۹-xxxx-xxxx';
    final accountName =
        dotenv.env['SUPPORT_ACCOUNT_NAME'] ?? 'شرکت آزاد اندیش داده‌ساز';
    final phoneNumber = dotenv.env['SUPPORT_PHONE_NUMBER'] ?? '۰۹۱۲۳۴۵۶۷۸۹';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline, color: Colors.amber, size: 20),
              SizedBox(width: 8),
              Text(
                'راهنمای پرداخت کارت به کارت',
                style: TextStyle(
                  fontFamily: 'Vazir',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.brown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'شماره کارت: $cardNumber ($accountName)',
            style: const TextStyle(fontFamily: 'Vazir', fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            'لطفاً پس از ثبت سفارش و تایید، شماره قبض/پیگیری را به شماره $phoneNumber پیامک کنید.',
            style: const TextStyle(
              fontFamily: 'Vazir',
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(
    CartItemModel item,
    ProductModel product,
    BuildContext context,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                product.mainImage,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
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
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'قیمت: ${product.price.toInt()}',
                    style: const TextStyle(
                      fontFamily: 'Vazir',
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _decrementQuantity(item),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        'تعداد: ${item.quantity}',
                        style: const TextStyle(fontFamily: 'Vazir'),
                      ),
                      IconButton(
                        onPressed: () => _incrementQuantity(item),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                await cartService.removeItemFromCart(item.productId);
                _refreshCart();
              },
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(double totalAmount, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'مبلغ کل:',
                style: TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${totalAmount.toInt()}',
                style: const TextStyle(
                  fontFamily: 'Vazir',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _handleCheckout(totalAmount),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF333333),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'نهایی کردن خرید',
              style: TextStyle(
                fontFamily: 'Vazir',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
