// lib/features/feat_product/pages/product_detail_page.dart
import 'package:flutter/material.dart';
import 'package:my_estahban_city/features/feat_product/models/product_model.dart';
import 'package:my_estahban_city/services/cart_service.dart';
import 'package:my_estahban_city/core/widgets/add_to_cart_button.dart';
import 'package:my_estahban_city/features/feat_product/pages/full_screen_image_page.dart';

class ProductDetailPage extends StatefulWidget {
  static const String routeName = '/product-detail';

  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final CartService cartService = CartService();

  List<String> _getAllImages() {
    final List<String> images = [widget.product.mainImage];
    images.addAll(widget.product.galleryImages);
    return images;
  }

  @override
  Widget build(BuildContext context) {
    final allImages = _getAllImages();
    final initialImageIndex = 0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.product.name,
            style: const TextStyle(
              fontFamily: 'Vazir',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.product.mainImage.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FullScreenImagePage(
                          images: allImages,
                          heroTag: 'product-image-${widget.product.id}',
                          initialIndex: initialImageIndex,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'product-image-${widget.product.id}',
                    child: Image.network(
                      widget.product.mainImage,
                      fit: BoxFit.cover,
                      height: 300,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          height: 300,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(
                            height: 300,
                            child: Center(child: Icon(Icons.error)),
                          ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'قیمت: ${widget.product.price.toInt()} تومان',
                      style: const TextStyle(
                        fontFamily: 'Vazir',
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.product.description,
                      style: const TextStyle(fontFamily: 'Vazir', fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: AddToCartButton(productId: widget.product.id),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
