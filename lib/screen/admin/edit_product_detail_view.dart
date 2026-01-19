import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/admin/image_upload_controller.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/widget/bot_nav_widget.dart';

class EditProductDetailView extends GetView<ImageUploadController> {
  const EditProductDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('تحميل المنتج ...'),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              title: Text(controller.product.value?.title ?? ''),
              expandedHeight: 50,
              backgroundColor: Colors.white,
              elevation: 0.5,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Get.back(),
              ),
            ),
            // Product Images Section
            SliverToBoxAdapter(child: _buildImageSection(context)),

            SliverToBoxAdapter(child: SizedBox(height: 8)),

            // Product Details Section
            SliverToBoxAdapter(child: _buildDeliveryForm(controller, context)),
            SliverToBoxAdapter(child: SizedBox(height: 8)),

            SliverToBoxAdapter(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'تعديل الصورة :',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => controller.pickNewImage(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            child: const Text("اختر الصورة"),
                          ),
                          SizedBox(width: 8),
                          controller.selectedImage.value != null
                              ? Image.file(
                                  controller.selectedImage.value!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.image,
                                  size: 100,
                                ), // Placeholder
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 8)),

            SliverToBoxAdapter(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                child: Column(children: [_buildOrderNotes(controller)]),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: BotNavWidget(
        // pro: controller.product.value!,
        controller: controller,
        isIcon: false,
        onPressed: () =>
            controller.updateProductImage(controller.product.value!.id),
        updateProductImage: "تحديث المنتج",
      ),
    );
  }
  //  Padding(
  //                 padding: EdgeInsets.all(16),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Obx(() {
  //                       return Row(
  //                         children: [
  //                           Expanded(
  //                             child: SizedBox(
  //                               // width: 200,
  //                               child: _buildDeliveryForm(controller),
  //                             ),
  //                           ),

  //                           Column(
  //                             children: [
  //                               _buildTitleSection(),

  //                               controller.selectedImage.value != null
  //                                   ? Image.file(
  //                                       controller.selectedImage.value!,
  //                                       height: 100,
  //                                       width: 100,
  //                                       fit: BoxFit.cover,
  //                                     )
  //                                   : const Icon(
  //                                       Icons.image,
  //                                       size: 100,
  //                                     ), // Placeholder

  //                               ElevatedButton(
  //                                 onPressed: () => controller.pickNewImage(),
  //                                 style: ElevatedButton.styleFrom(
  //                                   backgroundColor: Colors.red,
  //                                   foregroundColor: Colors.white,
  //                                   shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(7),
  //                                   ),
  //                                 ),
  //                                 child: const Text("اختر الصورة"),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       );
  //                     }),
  //                     _buildPriceSection(),
  //                     SizedBox(height: 16),
  //                     _buildDescriptionSection(controller),
  //                   ],
  //                 ),
  Widget _buildImageSection(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                PageView.builder(
                  onPageChanged: (index) => controller.selectImage(index),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      key: ValueKey(
                        '${controller.product.value?.image}_${DateTime.now().millisecondsSinceEpoch}',
                      ),

                      imageUrl:
                          '${AppLink.productsimages}${controller.product.value?.image}',
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.broken_image),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryForm(
    ImageUploadController controller,
    BuildContext context,
  ) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 9),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تعديل الاسم و السعر :',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          controller.product.value?.title ?? '',
                          style: TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: _buildTextField(
                          controller: controller.titleController,
                          label: 'اسم المنتج الجديد',
                          icon: Icons.production_quantity_limits,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          controller.product.value?.price ?? '',
                          style: TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: _buildTextField(
                          controller: controller.priceController,
                          label: 'السعر الجديد',
                          icon: Icons.price_check_sharp,
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'ادخل سعر المنتج الجديد ',

        prefixIcon: Icon(icon, color: Colors.blue[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildOrderNotes(ImageUploadController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تفاصيل المنتج (اختياري)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            // controller: controller.notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText:
                  'اكتب وصفاً مفصلاً للمنتج... \n  ${controller.product.value?.description ?? 'بدون وصف'}',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
        ],
      ),
    );
  }
}
