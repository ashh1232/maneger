import 'package:get/get.dart';
import 'package:maneger/binding/home_binding.dart';
import 'package:maneger/screen/admin/addproduct_screen.dart';
import 'package:maneger/screen/admin/edit_home_screen.dart';
import 'package:maneger/screen/admin/edit_product_detail_view.dart';
import 'package:maneger/screen/delivery/deli_map.dart';
import 'package:maneger/screen/delivery/order_details.dart';
import 'package:maneger/screen/home_screen.dart';
import 'package:maneger/screen/talabat/map_tal.dart';
import 'package:maneger/screen/talabat/talabat_home_screen.dart';
import 'package:maneger/screen/talabat/checkout_screen.dart';
import 'package:maneger/screen/delivery/deli_home.dart';
import 'package:maneger/screen/edit/add_new_cat.dart';
import 'package:maneger/screen/edit/edit_cat_details.dart';
import 'package:maneger/screen/edit/edit_cat_screen.dart';
import 'package:maneger/screen/editbanner/add_banner.dart';
import 'package:maneger/screen/editbanner/edit_ban_details.dart';
import 'package:maneger/screen/editbanner/edit_ban_screen.dart';
import 'package:maneger/screen/talabat/order_confirmation_screen.dart';
import 'package:maneger/screen/talabat/product_detail_view.dart';
import 'package:maneger/screen/talabat/profile_screen.dart';
// <<<<<<< HEAD
// import 'package:maneger/trash/db/product_list_screen.dart';
// import 'package:maneger/trash/edit_add_screen.dart';
// import 'package:maneger/trash/ani_appbar_screen.dart';
import 'package:maneger/screen/talabat/cart_page.dart';
// import 'package:maneger/trash/home_screen.dart';
import 'package:maneger/screen/auth/login_screen.dart';
import 'package:maneger/screen/message_view.dart';
import 'package:maneger/test/flut_map.dart';
// import 'package:maneger/trash/product_detail_view.dart';
import 'package:maneger/trash/salon_screen.dart';
import 'package:maneger/screen/auth/signup_screen.dart';
import 'package:maneger/screen/talabat/category_page.dart';
// import 'trash/edit_cat_screen.dart';
// import 'trash/profile_screen.dart';
// =======
// import 'package:newmanager/screen/cart_page.dart';
// import 'package:newmanager/screen/login_screen.dart';
// import 'package:newmanager/screen/message_view.dart';
// import 'package:newmanager/trash/salon_screen.dart';
// import 'package:newmanager/screen/signup_screen.dart';
// import 'package:newmanager/screen/shein_page.dart';
// >>>>>>> ba93ef8 (work)
// import 'package:newmanager/screen/admin/addproduct_screen.dart';

class AppRoutes {
  static const home = '/';
  static const talabatScreen = '/talabatScreen';
  static const login = '/login';
  static const signup = '/signup';
  static const profile = '/profile';
  static const category = '/shein';
  static const productDetail = '/detail';
  static const cartPage = '/cartPage';
  static const checkout = '/checkout';
  static const mapScreen = '/mapScreen';
  static const addscreen = '/addscreen';
  static const editCatDetailScreen = '/editCatDetailScreen';
  static const editProductScreen = '/editProductScreen';
  static const editCatScreen = '/editCatScreen';
  static const addnewcat = '/addnewcat';
  static const addbanner = '/addbanner';
  static const editBanScreen = '/editBanScreen';
  static const editBanDetailScreen = '/editBanDetailScreen';
  static const mail = '/mail';
  static const imageUploadScreen = '/imageUploadScreen';
  static const deliHome = '/delihome';
  static const orderConfirmation = '/order-confirmation';
  static const orderDetails = '/orderDetails';
  static const flutMap = '/flutMap';
  static const deliMap = '/deliMap';

  static final routes = [
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: signup, page: () => SignupScreen()),

    GetPage(name: home, page: () => HomeScreen(), binding: HomeBinding()),
    GetPage(
      name: talabatScreen,
      page: () => TalabatHomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(name: profile, page: () => ProfileScreen()),
    GetPage(name: category, page: () => CategoryPage()),
    GetPage(name: productDetail, page: () => ProductDetailView()),
    GetPage(name: mail, page: () => MessageView()),
    GetPage(name: cartPage, page: () => CartPage()),
    GetPage(name: checkout, page: () => CheckoutScreen()),
    GetPage(name: orderConfirmation, page: () => OrderConfirmationScreen()),
    GetPage(name: mapScreen, page: () => MapTal()),
    ////////////// admin
    GetPage(name: addscreen, page: () => AdminProductScreen()),
    GetPage(name: editProductScreen, page: () => EditProductDetailView()),
    GetPage(name: imageUploadScreen, page: () => ImageUploadScreen()),
    ////////////////// editcat
    GetPage(name: editCatDetailScreen, page: () => EditCatDetailView()),
    GetPage(name: editCatScreen, page: () => EditCategoryScreen()),
    GetPage(name: addnewcat, page: () => AddNewCat()),
    /////////////// banner
    GetPage(name: addbanner, page: () => AddBanner()),
    GetPage(name: editBanDetailScreen, page: () => EditBanDetailView()),
    GetPage(name: editBanScreen, page: () => EditBanScreen()),
    ////////////////// delivery
    GetPage(
      name: deliHome,
      page: () => DeliHome(),
      // binding: HomeBinding(),
    ),
    GetPage(name: orderDetails, page: () => OrderDetails()),
    GetPage(name: flutMap, page: () => FlutMap()),
    GetPage(name: deliMap, page: () => DeliMap()),
  ];
}

final List<GetPage> getPages = [
  // GetPage(name: '/home', page: () => HomeScreen()),
  GetPage(name: '/salon', page: () => SalonView()),
];
