import 'admin_link.dart';

class AppLink {
  // static const String server = 'http://10.70.100.148/doc/docana-back';
  // static const String server = 'http://192.168.43.19/doc/docana-back';
  // static const String server = 'http://192.168.1.66/docana-back';
  //
  // static const String image = 'http://192.168.1.66/img/';
  static const String image = AdminLink.image;
  // static const String image = 'http://10.70.100.148/img';
  // static const String server = 'http://10.0.2.2/doc/docana-back';
  // static const String server = 'http://192.168.43.19/doc/docana-back';
  static const String server = AdminLink.server;
  // static const String server = 'http://192.168.1.66/docana-back';
  //

  /////////////
  static const String product = '$server/product.php';
  static const String productt = '$server/product2.php';
  static const String banner = '$server/banner.php';
  static const String cat = '$server/catt.php';
  static const String update = '$server/update_test.php';
  static const String addpro = '$server/add_test.php';
  static const String login = '$server/login.php';
  // static const String signup = '$server/test.php';
  static const String signup = '$server/signup.php';
  static const String order = '$server/order/order.php';
  static const String profile = '$server/profile.php';
  ///////////////////
  // ////// admin
  static const String addProduct = '$server/admin/add_product.php';
  static const String uploadImage = '$server/admin/upload_image.php';
  static const String favorites = '$server/favorites.php';
  ////editcat
  static const String addnewcat = '$server/editcat/add_cat.php';

  ///
  static const String uploadcatImage = '$server/editcat/upload_cat_image.php';
  static const String category = '$server/editcat/edit_cat.php';
  static const String addnewbanner = '$server/banner/add_ban.php';
  static const String uploadbanImage = '$server/banner/upload_ban_image.php';

  ///images
  static const String productsimages = '$image/productsImages/';
  static const String catsimages = '$image/catsImages/';
  static const String bannersimages = '$image/bannersImages/';
  ///////////// delivery
  static const String delivery = '$server/delivery/delivery_order.php';
}
