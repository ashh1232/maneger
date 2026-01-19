import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:maneger/core/error/exceptions.dart';
import 'package:maneger/core/error/failures.dart';
import 'package:maneger/features/products/data/datasources/product_remote_datasource.dart';
import 'package:maneger/features/products/domain/entities/images.dart';
import 'package:maneger/features/products/domain/entities/product.dart';
import 'package:maneger/features/products/domain/entities/category.dart';
import 'package:maneger/features/products/domain/repositories/product_repository.dart';

/// Implementation of ProductRepository
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    int page = 1,
    int limit = 10,
    String? categoryId,
  }) async {
    try {
      final productModels = await remoteDataSource.getProducts(
        page: page,
        limit: limit,
        categoryId: categoryId,
      );

      // Convert models to entities
      final products = productModels.map((model) => model.toEntity()).toList();
      return Right(products);
    } on ServerException catch (e) {
      debugPrint('🔴 Get products failed: ${e.message}');
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      debugPrint('❌ Unknown get products error: $e');
      return const Left(UnknownFailure(message: 'Failed to fetch products'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      final productModel = await remoteDataSource.getProductById(id);
      return Right(productModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      debugPrint('❌ Get product by ID error: $e');
      return const Left(UnknownFailure(message: 'Failed to fetch product'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    try {
      final productModels = await remoteDataSource.searchProducts(query);
      final products = productModels.map((model) => model.toEntity()).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      debugPrint('❌ Search products error: $e');
      return const Left(UnknownFailure(message: 'Failed to search products'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    String categoryId,
  ) async {
    return getProducts(categoryId: categoryId);
  }

  @override
  Future<Either<Failure, List<Images>>> getImagesById(String id) async {
    // String categoryId,
    try {
      final categoryModels = await remoteDataSource.getImagess(id);
      final categories = categoryModels
          .map((model) => model.toEntity())
          .toList();
      return Right(categories);
    } on ServerException catch (e) {
      debugPrint('🔴 Get categories failed: ${e.message}');
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      debugPrint('❌ Unknown get categories error: $e');
      return const Left(UnknownFailure(message: 'Failed to fetch categories'));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categoryModels = await remoteDataSource.getCategories();
      final categories = categoryModels
          .map((model) => model.toEntity())
          .toList();
      return Right(categories);
    } on ServerException catch (e) {
      debugPrint('🔴 Get categories failed: ${e.message}');
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      debugPrint('❌ Unknown get categories error: $e');
      return const Left(UnknownFailure(message: 'Failed to fetch categories'));
    }
  }

  @override
  Future<Either<Failure, List<Banner>>> getBanners() async {
    try {
      final bannerModels = await remoteDataSource.getBanners();
      final banners = bannerModels.map((model) => model.toEntity()).toList();
      return Right(banners);
    } on ServerException catch (e) {
      debugPrint('🔴 Get banners failed: ${e.message}');
      return Left(ServerFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      debugPrint('❌ Unknown get banners error: $e');
      return const Left(UnknownFailure(message: 'Failed to fetch banners'));
    }
  }
}
