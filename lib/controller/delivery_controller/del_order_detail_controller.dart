import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/model/order_del_model.dart';
import 'package:maneger/model/order_model.dart';

class DeliveryOrderDetailController extends GetxController {
  Rx<StatusRequest> statusRequest = StatusRequest.offline.obs;
  final Crud _crud = Crud();
  var isLoading = false.obs;
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  // @override
  // void onInit() {
  //   super.onInit();
  // }

  var currentIndex = 0.obs;
  @override
  void onReady() {
    super.onReady();

    // ✅ الوصول للبيانات بدون ()
    var arg = Get.arguments;

    if (arg != null && arg is int) {
      // يمكنك الآن استخدام المعرف لجلب تفاصيل الطلب
      print("جاري جلب بيانات الطلب رقم: $arg");
      getOrders(arg);
    } else {
      // حالة احتياطية إذا لم يتم إرسال وسائط
      // getOrders();
    }
  }

  Future<void> getOrders(int orderId) async {
    print('object');
    if (isLoading.value) return;
    statusRequest.value = StatusRequest.loading;

    try {
      isLoading.value = true;
      var respo = await _crud.postData(AppLink.delivery, {
        'action': 'get_order_details',
        'order_id': '$orderId',
      });
      print(respo);
      respo.fold(
        (status) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Get.context != null && !Get.isSnackbarOpen) {
              Get.rawSnackbar(
                message: "خطأ في التحميل: $status",
                duration: Duration(seconds: 2),
              );
            }
          });
        },
        (res) {
          if (res['status'] == 'success') {
            statusRequest.value = StatusRequest.success;
            print(res['data']);
            //////////////
            final Map<String, dynamic> orderData = res['data'];
            final List<dynamic> items = orderData['items'];
            // final List<dynamic> decod = res['data'];
            print(orderData);
            // orders.value = orderData
            // .map((ban) => Order.fromJson(ban))
            // .toList();
            orders.value = [OrderModel.fromJson(res['data'])];
          } else {
            statusRequest.value = StatusRequest.failure;
          }
        },
      );
    } catch (e) {
      Get.snackbar(('error'), 'error $e');
      statusRequest.value = StatusRequest.failure;
    }
    isLoading.value = false;
  }

  void updateQuantity(int index, int quantity) {
    // product[index].quantity = quantity;
  }

  void removeProduct(int index) {
    orders.removeAt(index);
  }
}
