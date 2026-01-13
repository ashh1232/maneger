import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/bannercontroller/edit_detail_ban_controller.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/model/bunner_model.dart';

class EditBanDetailView extends GetView<EditDetailBanController> {
  EditBanDetailView({super.key});
  final cat = Get.arguments as Bunner;
  @override
  Widget build(BuildContext context) {
    final EditDetailBanController controller = Get.put(
      EditDetailBanController(),
    );

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
              expandedHeight: 50,
              backgroundColor: Colors.white,
              elevation: 0.5,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Get.back(),
              ),
            ),
            // Product Images Section
            SliverToBoxAdapter(child: _buildImageSection()),
            // Product Details Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        controller.updateProductImage(cat.id);
                      },
                      child: const Text("تعديل الصورة"),
                    ),
                    Obx(() {
                      return Column(
                        children: [
                          controller.selectedImage.value != null
                              ? Image.file(
                                  controller.selectedImage.value!,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.image,
                                  size: 200,
                                ), // Placeholder

                          ElevatedButton(
                            onPressed: () => controller.pickNewImage(),
                            child: const Text("اختر الصورة"),
                          ),
                        ],
                      );
                    }),
                    _buildPriceSection(),
                    SizedBox(height: 16),
                    _buildTitleSection(),
                    SizedBox(height: 16),
                    _buildActionButtons(),
                    SizedBox(height: 24),
                    _buildQuantitySection(),
                    SizedBox(height: 16),
                    _buildDescriptionSection(),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildImageSection() {
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
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: '${AppLink.image}${cat.image}',
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
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Row(
      children: [
        Text(
          '\$${controller.cat.name}',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Text(
      cat.name,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildQuantitySection() {
    return Row(
      children: [
        Text(
          'الكمية',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Spacer(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            child: Text(
              'اضف الى السله',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 12),
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
