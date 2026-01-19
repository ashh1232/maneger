import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:maneger/core/error/failures.dart';
import 'package:maneger/features/products/domain/entities/images.dart';
import 'package:maneger/features/products/domain/repositories/product_repository.dart';

/// Use case for fetching products with pagination
///
/// Handles the business logic for retrieving paginated products
class GetImagesUseCase {
  final ProductRepository repository;

  GetImagesUseCase(this.repository);

  /// Execute get products
  ///
  // / Fetches products with pagination support
  Future<Either<Failure, List<Images>>> call(GetImagesParams params) async {
    return await repository.getImagesById(params.id);
  }
}

/// Parameters for get products use case
class GetImagesParams extends Equatable {
  final String id;

  const GetImagesParams({this.id = '1'});

  @override
  List<Object?> get props => [id];
}
