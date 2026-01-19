import 'package:dartz/dartz.dart';
import 'package:maneger/core/error/exceptions.dart';
import 'package:maneger/core/error/failures.dart';
import 'package:maneger/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:maneger/features/cart/data/models/cart_item_model.dart';
import 'package:maneger/features/cart/domain/entities/cart_item.dart';
import 'package:maneger/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      final items = await localDataSource.getCartItems();
      return Right(items);
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(CartItem item) async {
    try {
      final currentItems = await localDataSource.getCartItems();

      // Check if item already exists
      final index = currentItems.indexWhere(
        (i) => i.product.id == item.product.id,
      );

      if (index >= 0) {
        // Update quantity
        final existingItem = currentItems[index];
        final newItem = existingItem.copyWith(
          quantity: existingItem.quantity + item.quantity,
          // You might want to update other fields like price if they changed
        );
        currentItems[index] = CartItemModel.fromEntity(newItem);
      } else {
        // Add new
        currentItems.add(CartItemModel.fromEntity(item));
      }

      await localDataSource.cacheCartItems(currentItems);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(String productId) async {
    try {
      final currentItems = await localDataSource.getCartItems();
      currentItems.removeWhere((item) => item.product.id == productId);
      await localDataSource.cacheCartItems(currentItems);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(
    String productId,
    int quantity,
  ) async {
    try {
      final currentItems = await localDataSource.getCartItems();
      final index = currentItems.indexWhere((i) => i.product.id == productId);

      if (index >= 0) {
        if (quantity <= 0) {
          currentItems.removeAt(index);
        } else {
          final existingItem = currentItems[index];
          currentItems[index] = CartItemModel.fromEntity(
            existingItem.copyWith(quantity: quantity),
          );
        }
        await localDataSource.cacheCartItems(currentItems);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> toggleSelection(
    String productId,
    bool isSelected,
  ) async {
    try {
      final currentItems = await localDataSource.getCartItems();
      final index = currentItems.indexWhere((i) => i.product.id == productId);

      if (index >= 0) {
        final existingItem = currentItems[index];
        currentItems[index] = CartItemModel.fromEntity(
          existingItem.copyWith(isSelected: isSelected),
        );
        await localDataSource.cacheCartItems(currentItems);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> toggleSelectAll(bool isSelected) async {
    try {
      final currentItems = await localDataSource.getCartItems();
      final updatedItems = currentItems.map((item) {
        return CartItemModel.fromEntity(item.copyWith(isSelected: isSelected));
      }).toList();

      await localDataSource.cacheCartItems(updatedItems);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.cacheCartItems([]);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
