import 'dart:convert';
import 'dart:core';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:maneger/class/statusrequest.dart';
import 'package:maneger/function/checkinternet.dart';

class Crud {
  // إضافة الـ Headers وتأكد من استخدامها
  Map<String, String> get _headers => {
    // هذا السطر يضمن للسيرفر أن البيانات القادمة هي UTF-8
    "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
    "Accept": "application/json",
  };

  Future<Either<StatusRequest, Map>> postData(String linkurl, Map data) async {
    try {
      if (await checkInternet()) {
        // تمرير الـ headers هنا ضروري جداً
        var response = await http
            .post(Uri.parse(linkurl), body: data, headers: _headers)
            .timeout(const Duration(seconds: 15));

        if (response.statusCode == 200 || response.statusCode == 201) {
          // استخدام utf8.decode يضمن عدم ظهور رموز غريبة إذا كان السيرفر يعيد نصاً عربياً
          var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
          return Right(responseBody);
        } else {
          return const Left(StatusRequest.serverfailure);
        }
      } else {
        return const Left(StatusRequest.offline);
      }
    } catch (e) {
      return const Left(StatusRequest.serverfailure);
    }
  }
}
