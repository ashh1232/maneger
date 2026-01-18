// lib/views/product_detail_view.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maneger/controller/product_controller.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/model/product_model.dart';
import 'package:maneger/widget/bot_nav_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailView extends GetView<ProductController> {
  final Product? manualProduct; // أضف هذا المتغير

  const ProductDetailView({super.key, this.manualProduct});

  @override
  Widget build(BuildContext context) {
    final Product? pro = manualProduct ?? Get.arguments;

    if (pro == null) {
      return const Scaffold(
        body: Center(child: Text("خطأ: لم يتم العثور على بيانات المنتج")),
      );
    }

    controller.product.value = pro;
    controller.quantity.value = 1;
    controller.product.value = pro;
    controller.image.value = [];

    controller.getImages(pro.id);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          // استخدام Obx فقط للمحتوى الذي يتأثر بالتحميل
          SliverList(
            delegate: SliverChildListDelegate([
              _buildImageSection(context, pro), // تمرير pro للدالة

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Container(
                    color: Theme.of(context).colorScheme.surface,
                    padding: EdgeInsets.all(7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        _buildPriceSection(pro), // تمرير pro
                        // const SizedBox(height: 5),
                        _buildTitleSection(pro),
                      ],
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    color: Theme.of(context).colorScheme.surface,
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        _buildRatingSection(),
                        // const SizedBox(height: 5),
                        _buildActionButtons(pro),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                  Container(
                    color: Theme.of(context).colorScheme.surface,
                    padding: EdgeInsets.all(8),
                    child: _buildDescriptionSection(),
                  ),

                  const SizedBox(height: 100),

                  // ... بقية العناصر
                ],
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: BotNavWidget(
        updateProductImage: "إضافة إلى السلة",
        pro: pro,
        controller: controller,
        onPressed: () {
          controller.addToCart(
            id: pro.id,
            img: pro.image,
            title: pro.title,
            price: pro.price,
          );
        },
      ),

      //  _buildBottomAction(context, pro),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 40, // قم بتقليل هذا الرقم (الافتراضي 56)
      pinned: true,
      surfaceTintColor: Theme.of(context).colorScheme.surface,

      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Get.back(),
      ),
      title: Text(
        controller.product.value?.title ?? "تفاصيل المنتج",
        style: GoogleFonts.lalezar(fontSize: 28), // تصغير الخط قليلاً
        textAlign: TextAlign.start,
        maxLines: 1,
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, Product pro) {
    return Obx(() {
      int totalImages = controller.image.length + 1;

      return Column(
        children: [
          SizedBox(
            height: 400,
            child: Stack(
              children: [
                PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: (index) =>
                      controller.currentImageIndex.value = index,
                  itemCount: totalImages,
                  itemBuilder: (context, index) {
                    String imageUrl = index == 0
                        ? (AppLink.productsimages + pro.image)
                        : (AppLink.productsimages +
                              controller.image[index - 1].image);

                    return CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.broken_image),
                    );
                  },
                ),
                if (controller.image.isNotEmpty)
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: controller.pageController, // الربط المباشر
                        count: totalImages, // سيتحدث تلقائياً بفضل Obx
                        effect: ScrollingDotsEffect(
                          activeDotColor: Colors.white,
                          dotColor: Colors.grey.shade500,
                          dotHeight: 11,
                          dotWidth: 5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            height: 80,
            child: Obx(
              () => ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.image.length + 1,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => controller.selectImage(index),
                    child: Obx(
                      () => Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 80, // تحديد عرض للصور المصغرة
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: controller.currentImageIndex.value == index
                                ? Colors.grey.shade600
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: CachedNetworkImage(
                            imageUrl: index == 0
                                ? (AppLink.productsimages + pro.image)
                                : (AppLink.productsimages +
                                      controller.image[index - 1].image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildPriceSection(Product pro) {
    final double currentPrice = double.tryParse(pro.price.toString()) ?? 0.0;
    final double oldPrice =
        double.tryParse(pro.originalPrice.toString()) ?? 0.0;
    final double discount = oldPrice > currentPrice
        ? ((oldPrice - currentPrice) / oldPrice) * 100
        : 0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // السعر الحالي بخط عريض وواضح
          Text(
            "$currentPrice شيكل",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(width: 12),
          // عرض السعر القديم والخصم إذا وجد
          if (discount > 0) ...[
            Text(
              "$oldPrice",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "-${discount.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
          const Spacer(),
          // حالة المخزون (Inventory Status) لزيادة الثقة
          const Text(
            "متوفر",
            style: TextStyle(color: Colors.green, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        // النجوم (يمكن استبدالها بـ RatingBar إذا كنت تستخدم مكتبة خارجية)
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < 4 ? Icons.star : Icons.star_half, // مثال لتقييم 4.5
              color: Colors.amber,
              size: 20,
            );
          }),
        ),
        const SizedBox(width: 8),
        const Text(
          "4.5",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(width: 4),
        Text(
          "(120 مراجعة)",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildTitleSection(Product pro) {
    return Text(
      pro.title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }

  // Widget _buildColorSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Color',
  //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //       ),
  //       SizedBox(height: 8),
  //       // Obx(
  //       //   () => Wrap(
  //       //     spacing: 8,
  //       //     children:
  //       //         controller.product.value.colors.map((color) {
  //       //           return ChoiceChip(
  //       //             label: Text(color),
  //       //             selected: controller.selectedColor.value == color,
  //       //             onSelected: (selected) => controller.changeColor(color),
  //       //             backgroundColor: Colors.grey.shade200,
  //       //             selectedColor: Colors.blue,
  //       //             labelStyle: TextStyle(
  //       //               color:
  //       //                   controller.selectedColor.value == color
  //       //                       ? Colors.white
  //       //                       : Colors.black,
  //       //             ),
  //       //           );
  //       //         }).toList(),
  //       //   ),
  //       // ),
  //     ],
  //   );
  // }

  // Widget _buildSizeSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Size',
  //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //       ),
  //       SizedBox(height: 8),
  //       // Obx(
  //       //   () => Wrap(
  //       //     spacing: 8,
  //       //     children:
  //       //         controller.product.value.sizes.map((size) {
  //       //           return ChoiceChip(
  //       //             label: Text(size),
  //       //             selected: controller.selectedSize.value == size,
  //       //             onSelected: (selected) => controller.changeSize(size),
  //       //             backgroundColor: Colors.grey.shade200,
  //       //             selectedColor: Colors.blue,
  //       //             labelStyle: TextStyle(
  //       //               color:
  //       //                   controller.selectedSize.value == size
  //       //                       ? Colors.white
  //       //                       : Colors.black,
  //       //             ),
  //       //           );
  //       //         }).toList(),
  //       //   ),
  //       // ),
  //     ],
  //   );
  // }

  // Widget _buildQuantitySection() {
  //   return Row(
  //     children: [
  //       Text(
  //         'Quantity',
  //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //       ),
  //       Spacer(),
  //       Container(
  //         decoration: BoxDecoration(
  //           border: Border.all(color: Colors.grey.shade300),
  //           borderRadius: BorderRadius.circular(4),
  //         ),
  //         child: Row(
  //           children: [
  //             IconButton(
  //               icon: Icon(Icons.remove, size: 20),
  //               onPressed: controller.decreaseQuantity,
  //               constraints: BoxConstraints(minWidth: 36, minHeight: 36),
  //             ),
  //             Obx(
  //               () => Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 16),
  //                 child: Text(
  //                   '${controller.quantity.value}',
  //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //             ),
  //             // IconButton(
  //             // icon: Icon(Icons.add, size: 20),
  //             // onPressed: controller.increaseQuantity,
  //             // constraints: BoxConstraints(minWidth: 36, minHeight: 36),
  //             // ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildStockSection() {
  //   return Obx(
  //     () => Container(
  //       padding: EdgeInsets.all(12),
  //       decoration: BoxDecoration(
  //         color:
  //             // controller.product.value.stock > 5
  //             //     ? Colors.green.shade50
  //             //     :
  //             Colors.orange.shade50,
  //         border: Border.all(
  //           color:
  //               // controller.product.value.stock > 5
  //               //     ? Colors.green.shade300
  //               //     :
  //               Colors.orange.shade300,
  //         ),
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       child: Row(
  //         children: [
  //           Icon(
  //             // controller.product.value.stock > 0
  //             // ? Icons.check_circle
  //             // :
  //             Icons.cancel,
  //             color:
  //                 // controller.product.value.stock > 0
  //                 //     ? Colors.green
  //                 //     :
  //                 Colors.red,
  //           ),
  //           SizedBox(width: 8),
  //           Text(
  //             '',
  //             // controller.product.value.stock > 0
  //             //     ? 'In Stock (${controller.product.value.stock} available)'
  //             //     : 'Out of Stock',
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _buildActionButtons(Product pro) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "الكمية:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Container(
              height: 35,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => controller.decreaseQuantity(),
                    icon: const Icon(
                      Icons.remove,
                      color: Color(0xFFC2C2C2),
                      size: 20,
                    ),
                  ),
                  Obx(
                    () => Text(
                      "${controller.quantity.value}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => controller.increaseQuantity(),
                    icon: const Icon(Icons.add, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تفاصيل المنتج',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Obx(
          () => Text(
            controller.product.value?.description ?? '',
            style: TextStyle(color: Colors.grey.shade700, height: 1.6),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'معلومات الشحن',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'شحن مجاني على الطلبات فوق \$50. التوصيل القياسي يستغرق 7-15 يوم عمل.',
          style: TextStyle(color: Colors.grey.shade700, height: 1.6),
        ),
        SizedBox(height: 16),
        Text(
          'سياسة الارجاع',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'ضمان استرداد المال لمدة 30 يوما. بدون استفسارات.',
          style: TextStyle(color: Colors.grey.shade700, height: 1.6),
        ),
      ],
    );
  }

  Widget? _buildBottomAction(BuildContext context, Product pro) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      width: double.infinity,
      height: 55,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              onPressed: () {
                controller.addToCart(
                  id: pro.id,
                  img: pro.image,
                  title: pro.title,
                  price: pro.price,
                );
              },
              child: const Text(
                "إضافة إلى السلة",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 5),
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isFavorite.value
                    ? Icons.favorite
                    : Icons.favorite_border,
                size: 30,
              ),
              onPressed: () => controller.toggleFavorite(),
            ),
          ),
        ],
      ),
    );
  }
}
