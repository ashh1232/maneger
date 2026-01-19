import 'package:equatable/equatable.dart';

/// Pure domain entity for Product
///
/// This is the business logic representation of a product.
/// No JSON, no dependencies - can be tested without Flutter.
class Product extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final String categoryId;
  final String categoryName;
  final String? blurHash;
  final DateTime? createdAt;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.categoryId,
    required this.categoryName,
    this.blurHash,
    this.createdAt,
  });

  /// Business logic: Calculate discount percentage
  double get discountPercentage {
    if (originalPrice <= 0) return 0.0;
    return ((originalPrice - price) / originalPrice) * 100;
  }

  /// Business logic: Check if product is on sale
  bool get isOnSale => price < originalPrice;

  /// Business logic: Check if product has valid image
  bool get hasImage => imageUrl.isNotEmpty && imageUrl != 'null';

  /// Business logic: Get display price
  String get displayPrice => price.toStringAsFixed(2);

  /// Business logic: Get display original price
  String get displayOriginalPrice => originalPrice.toStringAsFixed(2);

  /// Copy with for immutability
  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    double? originalPrice,
    String? imageUrl,
    String? categoryId,
    String? categoryName,
    String? blurHash,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      blurHash: blurHash ?? this.blurHash,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    price,
    originalPrice,
    imageUrl,
    categoryId,
    categoryName,
    blurHash,
    createdAt,
  ];

  @override
  String toString() => 'Product(id: $id, title: $title, price: $price)';
}
