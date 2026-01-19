import 'package:dartz/dartz.dart';
import 'package:maneger/core/error/failures.dart';
import 'package:maneger/features/products/domain/entities/images.dart';
import 'package:maneger/features/products/domain/entities/product.dart';
import 'package:maneger/features/products/domain/entities/category.dart';

/// Repository contract for products
///
/// Defines the contract for product data operations
abstract class ProductRepository {
  /// Get paginated list of products
  ///
  /// Returns list of [Product] or [Failure]
  Future<Either<Failure, List<Product>>> getProducts({
    int page = 1,
    int limit = 20,
    String? categoryId,
  });
  //////GEt Images
  Future<Either<Failure, List<Images>>> getImagesById(String id);

  /// Get single product by ID
  Future<Either<Failure, Product>> getProductById(String id);

  /// Search products
  Future<Either<Failure, List<Product>>> searchProducts(String query);

  /// Get products by category
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    String categoryId,
  );

  /// Get all categories
  Future<Either<Failure, List<Category>>> getCategories();

  /// Get all banners
  Future<Either<Failure, List<Banner>>> getBanners();
}
