import 'package:dartz/dartz.dart';
import 'package:maneger/core/error/failures.dart';
import 'package:maneger/core/usecase/usecase.dart';
import 'package:maneger/features/cart/domain/repositories/cart_repository.dart';

class ToggleSelectAllUseCase implements UseCase<void, bool> {
  final CartRepository repository;

  ToggleSelectAllUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(bool isSelected) async {
    return await repository.toggleSelectAll(isSelected);
  }
}
