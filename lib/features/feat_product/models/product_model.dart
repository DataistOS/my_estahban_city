// lib/features/feat_product/product_model.dart
import 'package:pocketbase/pocketbase.dart';
import 'package:my_estahban_city/services/pocketbase_instance.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double stock;
  final String category;
  final String mainImage;
  final List<String> galleryImages;
  final String? brand;
  final double? weight;
  final String? dimensions;
  final bool isAvailable;
  final String? barcodeId;
  final DateTime created;
  final DateTime updated;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.mainImage,
    required this.galleryImages,
    this.brand,
    this.weight,
    this.dimensions,
    required this.isAvailable,
    this.barcodeId,
    required this.created,
    required this.updated,
  });

  factory ProductModel.fromRecord(RecordModel record) {
    final String mainImageUrl = pocketBaseInstance.files
        .getURL(record, record.data['main_image'])
        .toString();

    final List<String> galleryUrls = [];
    if (record.data['gallery_images'] != null &&
        record.data['gallery_images'] is List) {
      for (var fileName in record.data['gallery_images']) {
        galleryUrls.add(
          pocketBaseInstance.files.getURL(record, fileName).toString(),
        );
      }
    }

    return ProductModel(
      id: record.id,
      name: record.data['name'],
      description: record.data['description'],
      price: record.data['price']?.toDouble() ?? 0.0,
      stock: record.data['stock']?.toDouble() ?? 0.0,
      category: record.data['category'],
      mainImage: mainImageUrl,
      galleryImages: galleryUrls,
      brand: record.data['brand'],
      weight: record.data['weight']?.toDouble(),
      dimensions: record.data['dimensions'],
      isAvailable: record.data['is_available'] ?? false,
      barcodeId: record.data['barcode_id'],
      created: DateTime.parse(record.get<String>('created')),
      updated: DateTime.parse(record.get<String>('updated')),
    );
  }

  Map<String, dynamic> toRecord() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'brand': brand,
      'weight': weight,
      'dimensions': dimensions,
      'is_available': isAvailable,
    };
  }
}
