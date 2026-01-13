import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:maneger/controller/admin/test_controller.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/model/bunner_model.dart';

// import 'package:talabat_admin/controller/test_controller.dart';
// import 'package:talabat_admin/linkapi.dart';

class EditDetailBanController extends GetxController {
  final cat = Get.arguments as Bunner;
  final RxInt currentImageIndex = 0.obs;

  // Reactive variables
  // var _imageFile = Rx<File?>(null);
  var isLoading = false.obs;
  var statusMessage = ''.obs;
  var uploadedImageUrl = ''.obs;
  var selectedImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  // 1. فنكشن اختيار الصورة
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
      statusMessage.value = "Image selected";
    }
  }

  // 2. الفنكشن التي كانت مفقودة (uploadImageToCloudinary)
  Future<void> uploadImageToCloudinary() async {
    if (selectedImage.value == null) {
      statusMessage.value = "الصورة مطلوبة";
      return;
    }
    try {
      isLoading.value = true;
      statusMessage.value = "جاري التحميل...";
      // --- ملاحظة: هنا تضع كود الرفع الخاص بك (Cloudinary API) ---
      // مثال وهمي للمحاكاة:
      await Future.delayed(const Duration(seconds: 2));
      // لنفترض أن الرفع نجح وحصلنا على رابط
      uploadedImageUrl.value = "cloudinary.com";
      statusMessage.value = "تم التحميل بنجاح!";
    } catch (e) {
      statusMessage.value = "Error: $e";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickNewImage() async {
    final ImagePicker picker = ImagePicker();
    // pickImage returns an XFile
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      // Convert XFile path to a standard File object
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> updateProductImage(String productId) async {
    if (selectedImage.value == null) {
      Get.snackbar('الصورة مطلوبة', 'الرجاء اختيار صورة جديدة أولا.');
      statusMessage.value = 'الصورة مطلوبة';
      return;
    }

    isLoading.value = true;
    statusMessage.value = 'تحديث صورة المنتج...';
    Get.snackbar('تحديث صورة المنتج', 'جاري تحديث صورة المنتج...');
    try {
      final url = Uri.parse(AppLink.uploadbanImage);
      final request = http.MultipartRequest('POST', url);
      // Add the product_id field so PHP knows which record to update
      request.fields['banner_id'] = productId;

      // Add the new image file
      request.files.add(
        await http.MultipartFile.fromPath('file', selectedImage.value!.path),
      );
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final result = jsonDecode(responseData);
        // print("Raw Server Response: $rawString");
        if (result['status'] == 'success') {
          uploadedImageUrl.value = result['filename'] ?? "";
          statusMessage.value = 'تم التحديث بنجاح!';
          Get.snackbar('تم التحديث', 'تم التحديث بنجاح!');

          // Refresh product list if necessary
          // Get.find<ProductController>().getData();
        } else {
          statusMessage.value = 'Error: ${result['message']}';
          Get.snackbar('Error', 'Error: ${result['message']}');
        }
      } else {
        statusMessage.value = 'Server error: ${response.statusCode}';
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      statusMessage.value = 'An error occurred: $e';
      Get.snackbar('title', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
    await Get.find<TestController>().getData();
    update();
  }

  void selectImage(int index) {
    currentImageIndex.value = index;
  }
}
