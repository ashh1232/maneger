import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/routes.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Details")),
      body: Center(
        child: InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.deliMap);
          },
          child: Column(
            children: [
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
