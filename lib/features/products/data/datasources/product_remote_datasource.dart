import 'package:flutter/foundation.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/core/error/exceptions.dart';
import 'package:maneger/core/network/api_client.dart';
import 'package:maneger/features/products/data/models/product_model.dart';
import 'package:maneger/features/products/data/models/category_model.dart';
import 'package:maneger/model/image_model.dart';

/// Remote data source for products
///
/// Handles all API calls related to products, categories, and banners
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 10,
    String? categoryId,
  });

  Future<ProductModel> getProductById(String id);
  Future<List<ProductModel>> searchProducts(String query);
  Future<List<CategoryModel>> getCategories();
  Future<List<ImageModel>> getImagess(String id);
  Future<List<BannerModel>> getBanners();
}

/// Implementation of ProductRemoteDataSource
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 10,
    String? categoryId,
  }) async {
    try {
      print(categoryId != null);
      // Build URL with pagination
      final url = categoryId != null
          ? '${ApiConstants.products}?page=$page&limit=$limit&category=$categoryId'
          : '${ApiConstants.product2}?page=$page';

      debugPrint(
        '📦 Fetching products: Page $page, Category: ${categoryId ?? "all"}',
      );

      // Make API request
      final response = await apiClient.get(url);

      // Parse response
      if (response['status'] == 'success' && response['data'] is List) {
        final List<dynamic> data = response['data'];
        final products = data
            .map((json) => ProductModel.fromJson(json))
            .toList();
        page++;

        print('objecdddddddddddddddt');
        debugPrint('✅ Fetched ${products.length} products');
        return products;
      } else if (response.containsKey('message')) {
        throw ServerException(
          message: response['message'],
          code: response['status'] ?? 'API_ERROR',
        );
      }

      throw ServerException(
        message: 'Invalid response format',
        code: 'INVALID_RESPONSE',
      );
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Get products error: $e');
      throw ServerException(
        message: 'Failed to fetch products',
        originalError: e,
      );
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await apiClient.get('${ApiConstants.products}?id=$id');

      if (response['status'] == 'success' && response['data'] != null) {
        return ProductModel.fromJson(response['data']);
      }

      throw ServerException(message: 'Product not found', code: 'NOT_FOUND');
    } catch (e) {
      debugPrint('❌ Get product by ID error: $e');
      throw ServerException(
        message: 'Failed to fetch product',
        originalError: e,
      );
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.products}?search=${Uri.encodeComponent(query)}',
      );

      if (response['status'] == 'success' && response['data'] is List) {
        final List<dynamic> data = response['data'];
        return data.map((json) => ProductModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      debugPrint('❌ Search products error: $e');
      throw ServerException(
        message: 'Failed to search products',
        originalError: e,
      );
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      debugPrint('📂 Fetching categories');

      final response = await apiClient.post(ApiConstants.categories, body: {});

      if (response['status'] == 'success' && response['data'] is List) {
        final List<dynamic> data = response['data'];
        final categories = data
            .map((json) => CategoryModel.fromJson(json))
            .toList();

        debugPrint('✅ Fetched ${categories.length} categories');
        return categories;
      }

      throw ServerException(
        message: 'Invalid response format',
        code: 'INVALID_RESPONSE',
      );
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Get categories error: $e');
      throw ServerException(
        message: 'Failed to fetch categories',
        originalError: e,
      );
    }
  }

  @override
  Future<List<ImageModel>> getImagess(String id) async {
    try {
      debugPrint('📂 Fetching categories');

      final response = await apiClient.post(
        ApiConstants.productImages,
        body: {'pro_id': id},
      );

      if (response['status'] == 'success' && response['data'] is List) {
        final List<dynamic> data = response['data'];
        final categories = data
            .map((json) => ImageModel.fromJson(json))
            .toList();

        debugPrint('✅ Fetched ${categories.length} categories');
        return categories;
      }

      throw ServerException(
        message: 'Invalid response format',
        code: 'INVALID_RESPONSE',
      );
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Get categories error: $e');
      throw ServerException(
        message: 'Failed to fetch categories',
        originalError: e,
      );
    }
  }

  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      debugPrint('🎨 Fetching banners');

      final response = await apiClient.post(ApiConstants.banners, body: {});

      if (response['status'] == 'success' && response['data'] is List) {
        final List<dynamic> data = response['data'];
        final banners = data.map((json) => BannerModel.fromJson(json)).toList();

        debugPrint('✅ Fetched ${banners.length} banners');
        return banners;
      }

      throw ServerException(
        message: 'Invalid response format',
        code: 'INVALID_RESPONSE',
      );
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Get banners error: $e');
      throw ServerException(
        message: 'Failed to fetch banners',
        originalError: e,
      );
    }
  }
}
