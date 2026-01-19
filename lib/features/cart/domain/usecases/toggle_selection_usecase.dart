import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:maneger/core/error/failures.dart';
import 'package:maneger/core/usecase/usecase.dart';
import 'package:maneger/features/cart/domain/repositories/cart_repository.dart';

class ToggleSelectionUseCase implements UseCase<void, ToggleSelectionParams> {
  final CartRepository repository;

  ToggleSelectionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleSelectionParams params) async {
    return await repository.toggleSelection(
      params.productId,
      params.isSelected,
    );
  }
}

class ToggleSelectionParams extends Equatable {
  final String productId;
  final bool isSelected;

  const ToggleSelectionParams({
    required this.productId,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [productId, isSelected];
}
