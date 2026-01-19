import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:maneger/core/error/failures.dart';
import 'package:maneger/features/products/domain/entities/product.dart';
import 'package:maneger/features/products/domain/repositories/product_repository.dart';

/// Use case for fetching products with pagination
///
/// Handles the business logic for retrieving paginated products
class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  /// Execute get products
  ///
  /// Fetches products with pagination support
  Future<Either<Failure, List<Product>>> call(GetProductsParams params) async {
    // Validation
    if (params.page < 1) {
      return const Left(
        ValidationFailure(message: 'Page number must be greater than 0'),
      );
    }

    if (params.limit < 1 || params.limit > 100) {
      return const Left(
        ValidationFailure(message: 'Limit must be between 1 and 100'),
      );
    }

    // Delegate to repository
    return await repository.getProducts(
      page: params.page,
      limit: params.limit,
      categoryId: params.categoryId,
    );
  }
}

/// Parameters for get products use case
class GetProductsParams extends Equatable {
  final int page;
  final int limit;
  final String? categoryId;

  const GetProductsParams({this.page = 1, this.limit = 20, this.categoryId});

  @override
  List<Object?> get props => [page, limit, categoryId];
}
