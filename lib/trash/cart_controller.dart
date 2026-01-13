import 'package:get/get.dart';

class CartItem {
  final String productId;
  final String productName;
  final String productImage;
  final int productPrice;
  int productCount;

  CartItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productCount,
  });
}

class CartController extends GetxController {
  var cart = <CartItem>[].obs;
  var username = ''.obs;
  var phone = ''.obs;
  var address = ''.obs;
  var formError = <String>[].obs;
  var deliveryFee = 0.obs;
  var subtotal = 0.obs;
  var total = 0.obs;

  void calculateTotal() {
    subtotal.value = cart.fold(
      0,
      (sum, item) => sum + item.productPrice * item.productCount,
    );
    deliveryFee.value = subtotal.value >= 100 ? 0 : 10;
    total.value = subtotal.value + deliveryFee.value;
  }

  void validateForm() {
    formError.clear();
    if (username.value.isEmpty) formError.add('اكتب اسمك');
    if (phone.value.isEmpty) formError.add('اكتب رقم هاتف');
    if (address.value.isEmpty) formError.add('اكتب عنوانك');
    if (username.value.isNotEmpty && username.value.length < 3) {
      formError.add('اكتب اسمك بشكل صحيح');
    }
    if (phone.value.isNotEmpty && phone.value.length != 10) {
      formError.add('اكتب رقمك بشكل صحيح');
    }
    if (formError.isEmpty) {
      makeOrder();
    }
  }

  void makeOrder() {
    // Implement order submission logic here
  }

  void addToCart(CartItem item) {
    item.productCount++;
    calculateTotal();
  }

  void removeFromCart(CartItem item) {
    item.productCount--;
    if (item.productCount == 0) {
      cart.remove(item);
    }
    calculateTotal();
  }

  void removeItem(CartItem item) {
    cart.remove(item);
    calculateTotal();
  }
}
