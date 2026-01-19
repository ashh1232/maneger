import 'package:maneger/features/products/domain/entities/product.dart';

/// Data Transfer Object for Product
///
/// Handles JSON serialization/deserialization
class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.originalPrice,
    required super.imageUrl,
    required super.categoryId,
    required super.categoryName,
    super.blurHash,
    super.createdAt,
  });

  /// Create ProductModel from JSON (API response)
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['id'] ?? json['product_id'] ?? '0').toString(),
      title: (json['title'] ?? json['product_name'] ?? 'No Title').toString(),
      description: (json['description'] ?? json['product_desc'] ?? '')
          .toString(),
      price: _parseDouble(json['price'] ?? json['product_price'] ?? '0'),
      originalPrice: _parseDouble(
        json['originalPrice'] ?? json['original_price'] ?? '0',
      ),
      imageUrl: (json['image'] ?? json['product_image'] ?? '').toString(),
      categoryId: (json['categoryId'] ?? json['product_cat'] ?? '0').toString(),
      categoryName: (json['cat_name'] ?? json['categories_name'] ?? '')
          .toString(),
      blurHash:
          json['product_blurhash'] as String? ?? json['blurhash'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  /// Helper to safely parse double values
  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price.toString(),
      'originalPrice': originalPrice.toString(),
      'image': imageUrl,
      'categoryId': categoryId,
      'cat_name': categoryName,
      'product_blurhash': blurHash,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Convert to domain entity
  Product toEntity() {
    return Product(
      id: id,
      title: title,
      description: description,
      price: price,
      originalPrice: originalPrice,
      imageUrl: imageUrl,
      categoryId: categoryId,
      categoryName: categoryName,
      blurHash: blurHash,
      createdAt: createdAt,
    );
  }

  /// Create from domain entity
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      title: product.title,
      description: product.description,
      price: product.price,
      originalPrice: product.originalPrice,
      imageUrl: product.imageUrl,
      categoryId: product.categoryId,
      categoryName: product.categoryName,
      blurHash: product.blurHash,
      createdAt: product.createdAt,
    );
  }
}
