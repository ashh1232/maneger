import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/delivery_controller/delivery_home_controller.dart';
import 'package:maneger/routes.dart';

class DeliOrder extends StatelessWidget {
  DeliOrder({super.key});
  final DeliveryHomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // حالة القائمة الفارغة
        if (controller.orders.isEmpty) {
          return const Center(
            child: Text(
              "لا توجد منتجات حالياً",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                controller.orders.clear();
                await controller.getOrders();
              },
            ),
            SliverAppBar(
              pinned: true,
              floating: false,
              expandedHeight: 220,
              elevation: 0,

              // title: SizedBox(height: 36, child: _buildSearchBar()),
              flexibleSpace: FlexibleSpaceBar(
                // background: _buildCarouselBanner(),
              ),
            ),

            SliverList.builder(
              itemCount: controller.orders.length,
              itemBuilder: (context, index) {
                final item = controller.orders[index];
                return InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.orderDetails);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // حواف أكثر انحناءً (موديل 2026)
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(
                            15,
                          ), // استخدام withAlpha بدلاً من withOpacity (أداء أفضل)
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "الكمية: ${item.itemCount}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Text(
                                    "الإجمالي: ",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    "${item.orderTotal} د.أ", // إضافة العملة
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // 3. زر الحذف مع تأثير بصري
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            // إضافة تأكيد حذف (اختياري)
                            controller.removeProduct(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}
