import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/features/cart/domain/entities/cart_item.dart';
import 'package:maneger/features/cart/presentation/controllers/cart_controller_clean.dart';
import 'package:maneger/features/products/domain/entities/product.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});
  // Use the new clean controller
  final CartControllerClean cartController = Get.find<CartControllerClean>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text('سلتك', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (cartController.cartItems.isEmpty) {
          return _buildEmptyCart();
        }

        return _buildCartContent(context);
      }),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'سلتك فارغه',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: cartController.continueShopping,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'Continue Shopping',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Obx(
                () => Checkbox(
                  value: cartController.selectAll.value,
                  onChanged: (value) {
                    cartController.toggleSelectAll(value ?? false);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Obx(
                () => Text(
                  'الكل (${cartController.cartItems.length})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Cart items
        Expanded(
          child: Obx(
            () => ListView.builder(
              itemCount: cartController.cartItems.length,
              itemBuilder: (context, index) {
                final item = cartController.cartItems[index];
                return _buildCartItem(context, item, index);
              },
            ),
          ),
        ),
        // Price summary and checkout
        _buildPriceSummary(context),
      ],
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item, int index) {
    final Product product = item.product;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Obx(
                // Use a key to force rebuild if item changes significantly
                // But for checkboxes, standard reactivity should work.
                // However, we need to access the reactive list from controller to ensure updates?
                // Actually 'item' here is from the list in global Obx, so it's fresh.
                // BUT 'item.isSelected' is a property of the CartItem Entity which is Equatable (immutable).
                // So when we toggle, we replace the item.
                // The parent ListView Obx will rebuild this widget completely.
                // So context.rebuild happens.
                () => Checkbox(
                  value: cartController.cartItems[index].isSelected,
                  onChanged: (value) {
                    cartController.updateSelectedCount(index, value ?? false);
                  },
                ),
              ),
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  key: ValueKey(product.imageUrl),

                  imageUrl: product.imageUrl.startsWith('http')
                      ? product.imageUrl
                      : "${ApiConstants.productsImages}/${product.imageUrl}",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  memCacheWidth: 200,
                  memCacheHeight: 200,
                  placeholder: (context, url) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          product.displayPrice, // Use displayPrice getter
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (product.originalPrice > product.price)
                          Text(
                            product.displayOriginalPrice,
                            style: TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey[500],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // Delete button
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () {
                  cartController.removeProduct(index);
                },
              ),
            ],
          ),
          // Quantity selector
          Padding(
            padding: const EdgeInsets.only(left: 44, top: 8),
            child: Row(
              children: [
                const Text(
                  'الكمية: ',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: item.quantity > 1
                            ? () => cartController.updateQuantity(
                                index,
                                item.quantity - 1,
                              )
                            : null,
                        child: const Icon(Icons.remove, size: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      InkWell(
                        onTap: () => cartController.updateQuantity(
                          index,
                          item.quantity + 1,
                        ),
                        child: const Icon(Icons.add, size: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'المجموع الفرعي:',
                  style: TextStyle(color: Colors.grey),
                ),
                Obx(
                  () => Text('${cartController.subtotal.toStringAsFixed(2)} ₪'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('التوصيل:', style: TextStyle(color: Colors.grey)),
                Obx(
                  () => Text('${cartController.delivery.toStringAsFixed(2)} ₪'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الإجمالي (شامل التوصيل):',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Obx(
                  () => Text(
                    '${cartController.total.toStringAsFixed(2)} ₪',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => cartController.checkout(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Obx(
                  () => Text(
                    'إتمام الشراء (${cartController.selectedCount.value})',
                    style: const TextStyle(
                      // color: Theme.,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
