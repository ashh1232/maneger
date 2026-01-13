import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:maneger/class/statusrequest.dart';
// import 'package:path/path.dart'; // ستحتاج لإضافة حزمة path في pubspec.yaml
import 'package:dartz/dartz.dart';
import 'package:path/path.dart';
// import 'package:talabat_admin/class/statusrequest.dart';

class ImageCrud {
  Future<Either<StatusRequest, Map>> postRequestWithFile(
    String url,
    Map data,
    File file,
  ) async {
    // 1. إنشاء طلب Multipart
    var request = http.MultipartRequest("POST", Uri.parse(url));

    // 2. إضافة الملف (الصورة) للطلب
    var length = await file.length();
    var stream = http.ByteStream(file.openRead());
    var multipartFile = http.MultipartFile(
      "files",
      stream,
      length,
      filename: basename(file.path),
    ); // "files" هو المفتاح المتوقع في السيرفر

    request.files.add(multipartFile);

    // 3. إضافة البيانات النصية (اسم المنتج، السعر، إلخ)
    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // 4. إرسال الطلب ومعالجة الاستجابة
    var myRequest = await request.send();
    var response = await http.Response.fromStream(myRequest);

    if (myRequest.statusCode == 200 || myRequest.statusCode == 201) {
      var responseBody = jsonDecode(response.body);
      // Map responseBody = jsonDecode(response.body);
      return Right(responseBody);
    } else {
      return const Left(StatusRequest.serverfailure);
    }
  }
}
