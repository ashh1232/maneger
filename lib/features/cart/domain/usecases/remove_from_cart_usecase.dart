import 'package:dartz/dartz.dart';
import 'package:maneger/core/error/failures.dart';
import 'package:maneger/core/usecase/usecase.dart';
import 'package:maneger/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCartUseCase implements UseCase<void, String> {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String productId) async {
    return await repository.removeFromCart(productId);
  }
}
