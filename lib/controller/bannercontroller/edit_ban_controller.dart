import 'package:get/get.dart';
import 'package:maneger/class/crud.dart';
import 'package:maneger/class/handlingdatacontroll.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/linkapi.dart';
import '../../model/bunner_model.dart';

class EditBanController extends GetxController {
  Crud crud = Crud();

  // تحويل الحالة لتكون قابلة للمراقبة (Rx)
  Rx<StatusRequest> statusRequest = StatusRequest.offline.obs;

  // قائمة المنتجات (Rx)
  RxList<Bunner> data = <Bunner>[].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    statusRequest.value = StatusRequest.loading;
    try {
      var respo = await crud.postData(AppLink.banner, {'action': 'get_cat'});
      statusRequest.value = handlingData(respo);
      // return
      if (statusRequest.value == StatusRequest.success) {
        respo.fold((l) => statusRequest.value = l, (r) {
          if (r['status'] == "success") {
            List<dynamic> decod = r['data'];
            data.assignAll(decod.map((e) => Bunner.fromJson(e)).toList());
          } else {
            statusRequest.value = StatusRequest.failure;
          }
        });
      }
    } catch (_) {
      statusRequest.value = StatusRequest.failure;
    }
  }
}
