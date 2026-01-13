import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/class/handlingdatacontroll.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/linkapi.dart';

import '../../model/cat_model.dart';

class EditCatController extends GetxController {
  Crud crud = Crud();

  // تحويل الحالة لتكون قابلة للمراقبة (Rx)
  Rx<StatusRequest> statusRequest = StatusRequest.offline.obs;

  // قائمة المنتجات (Rx)
  RxList<Category> data = <Category>[].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  gOtdata() async {
    var respo = await crud.postData(AppLink.category, {
      'action': 'get_cat',
      'cat_id': '5',
    });
    return respo.fold((l) => l, (r) => r);
  }

  Future<void> getData() async {
    statusRequest.value = StatusRequest.loading;
    var respo = await gOtdata();

    statusRequest.value = handlingData(respo);

    if (statusRequest.value == StatusRequest.success) {
      if (respo['status'] == "success") {
        List<dynamic> decod = respo['data'];
        data.assignAll(decod.map((e) => Category.fromJson(e)).toList());
      } else {
        statusRequest.value = StatusRequest.failure;
      }
    }
    // مع Obx، لا نحتاج لاستدعاء update()
  }
}
