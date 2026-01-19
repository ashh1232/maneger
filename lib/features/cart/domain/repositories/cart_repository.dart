import 'package:dartz/dartz.dart';
import 'package:maneger/core/error/failures.dart';
import 'package:maneger/features/cart/domain/entities/cart_item.dart';

/// Repository contract for Cart operations
abstract class CartRepository {
  /// Get all items in the cart
  Future<Either<Failure, List<CartItem>>> getCartItems();

  /// Add an item to the cart
  Future<Either<Failure, void>> addToCart(CartItem item);

  /// Remove an item from the cart
  Future<Either<Failure, void>> removeFromCart(String productId);

  /// Update item quantity
  Future<Either<Failure, void>> updateQuantity(String productId, int quantity);

  /// Toggle item selection
  Future<Either<Failure, void>> toggleSelection(
    String productId,
    bool isSelected,
  );

  /// Select/De-select all
  Future<Either<Failure, void>> toggleSelectAll(bool isSelected);

  /// Clear the cart (e.g. after checkout)
  Future<Either<Failure, void>> clearCart();
}
