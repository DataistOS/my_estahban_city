// lib/services/product_service.dart

import 'package:flutter/foundation.dart';

import 'package:my_estahban_city/services/pocketbase_instance.dart';
import 'package:my_estahban_city/features/feat_product/models/product_model.dart';
import 'package:my_estahban_city/core/errors/pocketbase_error_handler.dart';

class ProductService {
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final records = await pocketBaseInstance
          .collection('products')
          .getFullList(sort: '-created', filter: 'is_available = true');

      return records.map((record) => ProductModel.fromRecord(record)).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          'Error fetching all products: ${getFriendlyErrorMessage(e)} - Details: $e',
        );
      }
      rethrow;
    }
  }

  Future<List<ProductModel>> getShowcaseProducts(
    String showcaseCategoryId,
  ) async {
    try {
      final records = await pocketBaseInstance
          .collection('products')
          .getFullList(
            sort: '-created',
            filter: 'is_available = true && category = "$showcaseCategoryId"',
          );

      return records.map((record) => ProductModel.fromRecord(record)).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          'Error fetching showcase products: ${getFriendlyErrorMessage(e)} - Details: $e',
        );
      }
      rethrow;
    }
  }

  Future<ProductModel?> getProductByCode(String code) async {
    if (code.isEmpty) return null;

    try {
      final records = await pocketBaseInstance
          .collection('products')
          .getList(
            page: 1,
            perPage: 1,
            filter: 'barcode_id = "$code" && is_available = true',
          );

      if (records.items.isNotEmpty) {
        return ProductModel.fromRecord(records.items.first);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          'Error during barcode search: ${getFriendlyErrorMessage(e)} - Details: $e',
        );
      }
      return null;
    }
  }

  Future<List<String>> getAllBrands() async {
    try {
      final records = await pocketBaseInstance
          .collection('products')
          .getFullList(sort: '-created', filter: 'is_available = true');

      Set<String> brands = {};
      for (var record in records) {
        String? brand = record.data['brand'];
        if (brand != null && brand.trim().isNotEmpty) {
          brands.add(brand.trim());
        }
      }
      return brands.toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          'Error fetching brands: ${getFriendlyErrorMessage(e)} - Details: $e',
        );
      }
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductsByBrand(String brandName) async {
    try {
      final records = await pocketBaseInstance
          .collection('products')
          .getFullList(
            sort: '-created',
            filter: 'is_available = true && brand = "$brandName"',
          );

      return records.map((record) => ProductModel.fromRecord(record)).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          'Error fetching products by brand: ${getFriendlyErrorMessage(e)} - Details: $e',
        );
      }
      rethrow;
    }
  }

  Future<List<ProductModel>> getRelatedProducts(
    String categoryId,
    String currentProductId,
  ) async {
    try {
      final records = await pocketBaseInstance
          .collection('products')
          .getFullList(
            sort: '-created',
            filter:
                'is_available = true && category = "$categoryId" && id != "$currentProductId"',
          );

      return records.map((record) => ProductModel.fromRecord(record)).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          'Error fetching related products: ${getFriendlyErrorMessage(e)} - Details: $e',
        );
      }
      rethrow;
    }
  }
}
