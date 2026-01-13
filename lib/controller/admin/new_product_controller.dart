import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maneger/class/image_crud.dart';
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/linkapi.dart';
// import 'package:talabat_admin/class/image_crud.dart';
// import 'package:talabat_admin/class/statusrequest.dart';
// import 'package:talabat_admin/linkapi.dart';

class NewProductController extends GetxController {
  ImageCrud crud = ImageCrud();
  var statusRequest = StatusRequest.offline.obs;

  var selectedImage = Rxn<File>();
  var isLoading = false.obs;
  // أضف هذه الدالة داخل كلاس Crud لتحويل الأرقام تلقائياً قبل الإرسال
  Map _prepareData(Map data) {
    Map cleanedData = Map.from(data);
    cleanedData.forEach((key, value) {
      if (value is String) {
        cleanedData[key] = value
            .replaceAll('٠', '0')
            .replaceAll('١', '1')
            .replaceAll('٢', '2')
            .replaceAll('٣', '3')
            .replaceAll('٤', '4')
            .replaceAll('٥', '5')
            .replaceAll('٦', '6')
            .replaceAll('٧', '7')
            .replaceAll('٨', '8')
            .replaceAll('٩', '9');
      }
    });
    return cleanedData;
  }

  // حقول إدخال البيانات
  late TextEditingController nameController;
  late TextEditingController priceController;

  @override
  void onInit() {
    nameController = TextEditingController();
    priceController = TextEditingController();
    super.onInit();
  }

  // فنكشن اختيار الصورة
  Future<void> pickImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // ضغط الصورة لـ 70% لتقليل الحجم مع الحفاظ على الجودة
      maxWidth: 1000, // تحديد أقصى عرض للصورة
    );
    if (image != null) selectedImage.value = File(image.path);
  }

  // فنكشن إضافة المنتج والسيرفر
  // تأكد أن النوع هو Future<bool> وليس void
  Future<bool> addProduct() async {
    try {
      if (selectedImage.value == null ||
          nameController.text.isEmpty ||
          priceController.text.isEmpty) {
        Get.snackbar("تنبيه", "يرجى ملء جميع الحقول واختيار صورة");
        return false; // إرجاع false في حال عدم اكتمال البيانات
      }

      isLoading.value = true;
      var cleanedData = _prepareData({
        "name": nameController.text,
        "price": priceController.text,
      });

      var response = await crud.postRequestWithFile(
        AppLink.addProduct,
        cleanedData,
        selectedImage.value!,
      );

      isLoading.value = false;

      // يجب استخدام return أمام fold ليعيد النتيجة النهائية
      // print(response['message']);
      return response.fold(
        (l) {
          Get.snackbar("خطأ", "فشل في الاتصال");
          return false;
        },
        (r) {
          if (r['status'] == "success") {
            return true; // نجاح العملية
          } else {
            Get.snackbar("تنبيه", "فشل إضافة المنتج");
            return false;
          }
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("خطأ", "حدث خطأ غير متوقع");
      return false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
