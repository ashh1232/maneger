import 'package:dartz/dartz.dart';
import 'package:maneger/core/error/failures.dart';
import 'package:maneger/core/usecase/usecase.dart';
import 'package:maneger/features/products/domain/entities/category.dart';
import 'package:maneger/features/products/domain/repositories/product_repository.dart';

class GetBannersUseCase implements UseCase<List<Banner>, NoParams> {
  final ProductRepository repository;

  GetBannersUseCase(this.repository);

  @override
  Future<Either<Failure, List<Banner>>> call(NoParams params) async {
    return await repository.getBanners();
  }
}
