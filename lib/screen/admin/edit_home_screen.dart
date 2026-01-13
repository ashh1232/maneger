import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/controller/admin/test_controller.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/routes.dart';
import 'package:maneger/widget/loading_card.dart';

class AdminProductScreen extends StatelessWidget {
  const AdminProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TestController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text("المنتجات"),
        actions: [
          IconButton(
            onPressed: () async {
              await Get.toNamed(AppRoutes.imageUploadScreen);
              controller.getData(); // التحديث عند العودة
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      // استخدام Obx لمراقبة التغيرات تلقائياً
      body: Obx(() {
        if (controller.statusRequest.value == StatusRequest.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.statusRequest.value == StatusRequest.offline) {
          return const Center(child: Text("لا يوجد اتصال بالانترنت"));
        } else if (controller.statusRequest.value == StatusRequest.failure ||
            controller.data.isEmpty) {
          return const Center(child: Text("لا يوجد بيانات"));
        } else {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async => await controller.getData(),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: controller.data.length,
                  itemBuilder: (context, index) {
                    final product = controller.data[index];
                    return InkWell(
                      onTap: () => Get.toNamed(
                        AppRoutes.editProductScreen,
                        arguments: product,
                      ),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            Expanded(
                              child: CachedNetworkImage(
                                imageUrl: product.image.startsWith('http')
                                    ? product.image
                                    : '${AppLink.productsimages}/${product.image}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                // تعامل مع الخطأ في حال لم تحمل الصورة
                                placeholder: (context, url) => const Center(
                                  child: LoadingCard(height: 100),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.broken_image),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Column(
                                    children: [
                                      Text(
                                        product.price,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        product.originalPrice,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
