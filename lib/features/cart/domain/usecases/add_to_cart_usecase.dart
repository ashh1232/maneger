import 'package:dartz/dartz.dart';
import 'package:maneger/core/error/failures.dart';
import 'package:maneger/core/usecase/usecase.dart';
import 'package:maneger/features/cart/domain/entities/cart_item.dart';
import 'package:maneger/features/cart/domain/repositories/cart_repository.dart';

class AddToCartUseCase implements UseCase<void, CartItem> {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CartItem params) async {
    return await repository.addToCart(params);
  }
}
