// lib/views/product_detail_view.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/product_controller.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/model/product_model.dart';

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
    return Scaffold(
      body:
          // Obx(() {
          //   if (controller.isLoading.value) {
          //     return Center(
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           CircularProgressIndicator(),
          //           SizedBox(height: 16),
          //           Text('تحميل المنتج ...'),
          //         ],
          //       ),
          //     );
          //   }
          //   return
          CustomScrollView(
            slivers: [
              _buildAppBar(context),
              // استخدام Obx فقط للمحتوى الذي يتأثر بالتحميل
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildImageSection(pro), // تمرير pro للدالة
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pro.title),
                        Text(pro.description),
                        _buildPriceSection(pro), // تمرير pro
                        Text(pro.price.toString()),
                        const SizedBox(height: 16),
                        _buildRatingSection(),
                        const SizedBox(height: 16),
                        _buildTitleSection(pro),
                        const SizedBox(height: 16),
                        _buildActionButtons(),
                        const SizedBox(height: 16),

                        _buildDescriptionSection(),
                        // ... بقية العناصر
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true, // يبقى شريط العنوان في الأعلى عند التمرير
      floating: false,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Get.back();
        },
      ),
      title: Text(
        controller.product.value?.title ?? "تفاصيل المنتج",
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ),
      actions: [
        Obx(
          () => IconButton(
            icon: Icon(
              controller.isFavorite.value
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: controller.isFavorite.value ? Colors.red : Colors.black,
            ),
            onPressed: controller.toggleFavorite,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.share, color: Colors.black),
          onPressed: () => Get.snackbar('مشاركة', 'جاري مشاركة المنتج...'),
        ),
      ],
    );
  }

  Widget _buildImageSection(Product pro) {
    return Column(
      children: [
        Container(
          color: Color(0xFFF5F5F5),
          child: Column(
            children: [
              SizedBox(
                height: 400,
                child: Stack(
                  children: [
                    PageView.builder(
                      onPageChanged: (index) => controller.selectImage(index),
                      itemCount: 1,
                      // itemCount: pro.images.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: AppLink.productsimages + pro.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.broken_image),
                        );
                      },
                    ),
                    // Positioned(
                    //   bottom: 16,
                    //   left: 0,
                    //   right: 0,
                    //   child: Obx(
                    //     () => Center(
                    //       child: SmoothPageIndicator(
                    //         controller: PageController(
                    //           initialPage: controller.currentImageIndex.value,
                    //         ),
                    //         count: controller.product.value.images.length,
                    //         effect: ScrollingDotsEffect(
                    //           activeDotColor: Colors.white,
                    //           dotColor: Colors.grey.shade400,
                    //           dotHeight: 8,
                    //           dotWidth: 8,
                    //         ),
                    //         onDotClicked:
                    //             (index) => controller.selectImage(index),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              // SizedBox(
              //   height: 80,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     padding: EdgeInsets.symmetric(horizontal: 16),
              //     itemCount: pro.images.length,
              //     itemBuilder: (context, index) {
              //       return Obx(
              //         () => GestureDetector(
              //           onTap: () => controller.selectImage(index),
              //           child: Container(
              //             margin: EdgeInsets.only(right: 8),
              //             decoration: BoxDecoration(
              //               border: Border.all(
              //                 color:
              //                     controller.currentImageIndex.value == index
              //                         ? Colors.blue
              //                         : Colors.grey.shade300,
              //                 width: 2,
              //               ),
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //             child: ClipRRect(
              //               borderRadius: BorderRadius.circular(6),
              //               child: CachedNetworkImage(
              //                 imageUrl: pro.images[index],
              //                 fit: BoxFit.cover,
              //                 width: 70,

              //                 placeholder:
              //                     (context, url) => Center(
              //                       child: CircularProgressIndicator(),
              //                     ),
              //                 errorWidget:
              //                     (context, url, error) =>
              //                         Icon(Icons.broken_image),
              //               ),
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection(Product pro) {
    final double currentPrice = double.tryParse(pro.price.toString()) ?? 0.0;
    final double oldPrice =
        double.tryParse(pro.originalPrice.toString()) ?? 0.0;
    final double discount = oldPrice > currentPrice
        ? ((oldPrice - currentPrice) / oldPrice) * 100
        : 0;

    return Row(
      children: [
        Text(
          "$currentPrice د.أ",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        const SizedBox(width: 12),
        if (discount > 0) ...[
          Text(
            "$oldPrice د.أ",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "${discount.toInt()}% خصم",
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 20),
        const SizedBox(width: 4),
        const Text("4.8", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Text("(120 مراجعة)", style: TextStyle(color: Colors.grey[600])),
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
  Widget _buildActionButtons() {
    return Column(
      children: [
        // اختيار الكمية

        // زر الإضافة للسلة
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              controller.addToCart(
                id: controller.product.value!.id,
                img: controller.product.value!.image,
                title: controller.product.value!.title,
                price: controller.product.value!.price,
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
        const SizedBox(height: 24),
        Row(
          children: [
            const Text(
              "الكمية:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => controller.decreaseQuantity(),
                    icon: const Icon(Icons.remove),
                  ),
                  Obx(
                    () => Text(
                      "${controller.quantity.value}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => controller.increaseQuantity(),
                    icon: const Icon(Icons.add),
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
}
