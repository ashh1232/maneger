// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/state_manager.dart';
// import 'package:maneger/controller/ani_appbar_controller.dart';
import 'package:maneger/controller/fatatest.dart';

class Tost extends StatelessWidget {
  final controller = Get.put(DataController());
  Tost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Infinite Products")),
      body: Obx(() {
        // print('object');
        // print(controller.productList);
        if (controller.productList.isEmpty && controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          controller: controller.scrollController, // Attach the listener here
          itemCount:
              controller.productList.length +
              (controller.hasMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            // Show a loading spinner at the bottom if more data is coming
            if (index == controller.productList.length) {
              return Padding(
                padding: EdgeInsets.all(15),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final product = controller.productList[index];
            return ListTile(
              title: Text(product['product_name']),
              subtitle: Text("\$${product['price']}"),
            );
          },
        );
      }),
    );
  }
}
