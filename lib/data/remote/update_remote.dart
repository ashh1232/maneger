import 'package:maneger/class/crud.dart';
import 'package:maneger/linkapi.dart';

class ProductRemote {
  Crud crud;
  ProductRemote(this.crud);

  Future<Object> updateDate(
    String id,
    String name,
    String price,
    String image,
  ) async {
    var respo = await crud.postData(AppLink.update, {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
    });
    return respo.fold((l) => l, (r) => r);
  }

  Future<Object> addData(
    String name,
    String price,
    String image,
    String proCat,
  ) async {
    var respo = await crud.postData(AppLink.addpro, {
      'name': name,
      'price': price,
      'image': image,
      'product_cat': proCat,
    });
    return respo.fold((l) => l, (r) => r);
  }

  Future<Object> addUser(
    String name,
    String price,
    String image,
    int proCat,
  ) async {
    var respo = await crud.postData(AppLink.addpro, {
      'username': name,
      'email': price,
      'password': image,
      'phone': proCat,
    });
    return respo.fold((l) => l, (r) => r);
  }
}
