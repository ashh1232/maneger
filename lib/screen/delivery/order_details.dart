import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/delivery_controller/del_order_detail_controller.dart';
import 'package:maneger/controller/delivery_controller/deli_map_controller.dart';
import 'package:maneger/routes.dart';

class OrderDetails extends StatelessWidget {
  final Object? manualProduct;

  const OrderDetails({super.key, this.manualProduct});

  @override
  Widget build(BuildContext context) {
    final DeliveryOrderDetailController controller = Get.put(
      DeliveryOrderDetailController(),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Order Details")),
      body: Center(
        child: InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.deliMap);
          },
          child: Column(
            children: [
              Obx(
                () => controller.isLoading.value
                    ? Text('data')
                    : Text('${controller.orders[0].orderTotal}'),
              ),
              Text("Order Details"),
              Text("Order ID: 123456789"),
              Text("Order Date: 2022-01-01"),
              Text("Order Total: 100.00"),
              Text("Order Status: Pending"),
            ],
          ),
        ),
      ),
    );
  }
}
