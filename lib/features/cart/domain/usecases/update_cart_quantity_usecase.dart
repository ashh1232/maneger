import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:maneger/core/error/failures.dart';
import 'package:maneger/core/usecase/usecase.dart';
import 'package:maneger/features/cart/domain/repositories/cart_repository.dart';

class UpdateCartQuantityUseCase
    implements UseCase<void, UpdateCartQuantityParams> {
  final CartRepository repository;

  UpdateCartQuantityUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateCartQuantityParams params) async {
    return await repository.updateQuantity(params.productId, params.quantity);
  }
}

class UpdateCartQuantityParams extends Equatable {
  final String productId;
  final int quantity;

  const UpdateCartQuantityParams({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}
