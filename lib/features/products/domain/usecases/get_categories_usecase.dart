import 'package:dartz/dartz.dart';
import 'package:maneger/core/error/failures.dart';
import 'package:maneger/features/products/domain/entities/category.dart';
import 'package:maneger/features/products/domain/repositories/product_repository.dart';

/// Use case for fetching categories
class GetCategoriesUseCase {
  final ProductRepository repository;

  GetCategoriesUseCase(this.repository);

  /// Execute get categories
  Future<Either<Failure, List<Category>>> call() async {
    return await repository.getCategories();
  }
}

// End of file
