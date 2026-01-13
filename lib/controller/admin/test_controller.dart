import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/class/handlingdatacontroll.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/model/product_model.dart';

class TestController extends GetxController {
  final Crud crud = Crud(); // استخدام final أفضل

  Rx<StatusRequest> statusRequest = StatusRequest.offline.obs;
  RxList<Product> data = <Product>[].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  // دالة جلب البيانات الخام
  Future<dynamic> _fetchRawData() async {
    var respo = await crud.postData(AppLink.product, {});
    return respo.fold((l) => l, (r) => r);
  }

  Future<void> getData() async {
    // إظهار التحميل فقط إذا كانت القائمة فارغة (تحسين تجربة المستخدم)
    if (data.isEmpty) {
      statusRequest.value = StatusRequest.loading;
    }

    var respo = await _fetchRawData();
    statusRequest.value = handlingData(respo);

    if (statusRequest.value == StatusRequest.success) {
      if (respo['status'] == "success") {
        List<dynamic> decod = respo['data'];

        // تحويل البيانات وتحديث القائمة
        List<Product> newList = decod.map((e) => Product.fromJson(e)).toList();
        data.assignAll(newList);
      } else {
        // في حال نجح الطلب لكن السيرفر أعاد "no data"
        if (data.isEmpty) statusRequest.value = StatusRequest.failure;
      }
    }
  }
}
