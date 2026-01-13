import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/controller/edit/edit_cat.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/routes.dart';

class EditCategoryScreen extends StatelessWidget {
  const EditCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الكنترولر ليتم استخدامه في الصفحة
    final EditCatController controller = Get.put(EditCatController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("المنتجات"),
        actions: [
          IconButton(
            onPressed: () async {
              await Get.toNamed(AppRoutes.addnewcat);
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
                    final cat = controller.data[index];
                    return InkWell(
                      onTap: () => Get.toNamed(
                        AppRoutes.editCatDetailScreen,
                        arguments: cat,
                      ),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.network(
                                '${AppLink.catsimages}/${cat.image}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                // تعامل مع الخطأ في حال لم تحمل الصورة
                                errorBuilder: (ctx, err, stack) =>
                                    const Icon(Icons.broken_image),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                cat.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
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
