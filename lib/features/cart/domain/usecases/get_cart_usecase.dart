import 'package:dartz/dartz.dart';
import 'package:maneger/core/error/failures.dart';
import 'package:maneger/core/usecase/usecase.dart';
import 'package:maneger/features/cart/domain/entities/cart_item.dart';
import 'package:maneger/features/cart/domain/repositories/cart_repository.dart';

class GetCartUseCase implements UseCase<List<CartItem>, NoParams> {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  @override
  Future<Either<Failure, List<CartItem>>> call(NoParams params) async {
    return await repository.getCartItems();
  }
}
