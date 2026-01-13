import 'package:maneger/class/crud.dart';
import 'package:maneger/linkapi.dart';

class TestData {
  Crud crud;
  TestData(this.crud);

  Future<Object> getdata() async {
    var respo = await crud.postData(AppLink.product, {});
    // print(respo);
    return respo.fold((l) => l, (r) => r);
  }

  Future<Object> getCatt() async {
    var respo = await crud.postData(AppLink.cat, {});
    return respo.fold((l) => l, (r) => r);
  }

  Future<Object> addUser(
    String name,
    String price,
    String image,
    int proCat,
  ) async {
    var respo = await crud.postData(AppLink.signup, {
      'username': name,
      'email': price,
      'password': image,
      'phone': proCat,
    });
    return respo.fold((l) => l, (r) => r);
  }
}
