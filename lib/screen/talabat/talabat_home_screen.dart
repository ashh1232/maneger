import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:maneger/controller/talabat/talabat_controller.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/routes.dart';
import 'package:maneger/screen/talabat/product_detail_view.dart';
import 'package:maneger/service/theme_service.dart';
import 'package:maneger/widget/loading_card.dart';
import 'package:maneger/widget/product_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class TalabatHomeScreen extends StatelessWidget {
  TalabatHomeScreen({super.key});
  final TalabatController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body:
          // Obx(() {
          //   if (controller.statusRequest.value == StatusRequest.loading) {
          //     return const Center(child: CircularProgressIndicator());
          //   }
          //   return
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              // نتحقق من المسافة (مثلاً 50 بكسل)
              bool isOverThreshold = notification.metrics.pixels > 50;

              // التعديل الجوهري: لا نستدعي toggleScroll إلا إذا تغيرت الحالة فعلياً
              if (isOverThreshold != controller.isScrolled.value) {
                controller.toggleScroll(isOverThreshold);
              }
              return false; // نترك التنبيه يكمل مساره
            },
            child: CustomScrollView(
              controller: controller.scrollController,
              cacheExtent: 500,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    controller.page = 1; // Reset page to 1
                    controller.hasMore(true); // Allow loading again
                    controller.productList.clear(); // Clear old data
                    await controller.initData();
                  },
                ),
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  expandedHeight: 220,
                  elevation: 0,
                  title: SizedBox(
                    height: 36,
                    child: _buildSearchBar(controller),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildCarouselBanner(controller),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    height: 100,
                    // color: Get.isDarkMode ? Colors.black : Colors.grey.shade100,
                    child: _buildCobon(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      height: 220, // الارتفاع الكلي للشبكة
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        // إضافة التنسيق لجعل المسافات أفضل
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // سيظهر صفين فوق بعضهما البعض
                              mainAxisSpacing:
                                  10, // المسافة الأفقية بين العناصر
                              crossAxisSpacing:
                                  10, // المسافة الرأسية بين الصفين
                              childAspectRatio:
                                  0.8, // هام جداً: يتحكم في عرض العنصر (جرب 0.7 إلى 1.0)
                            ),
                        itemCount: controller.isCatLoading.value
                            ? 10 // عدد عناصر التحميل
                            : controller.catList.length,
                        itemBuilder: (context, index) {
                          if (controller.isCatLoading.value) {
                            return const LoadingCard(height: 20);
                          }
                          return HomeCatItems(
                            img:
                                controller.catList[index].image.startsWith(
                                  'https',
                                )
                                ? controller.catList[index].image
                                : AppLink.catsimages +
                                      controller.catList[index].image,
                            title: controller.catList[index].title,
                            controller: controller,
                            id: controller.catList[index].id,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 3,

                    childCount:
                        controller.isLoading.value &&
                            controller.productList.isEmpty
                        ? 9
                        : controller.productList.length +
                              (controller.hasMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.productList.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (controller.productList.isEmpty &&
                          controller.isLoading.value) {
                        return const LoadingCard(height: 150);
                      } else {
                        final product = controller.productList[index];
                        return OpenContainer(
                          transitionDuration: const Duration(milliseconds: 500),
                          // لون الخلفية أثناء الانتقال
                          openColor: Colors.white,
                          closedColor: Colors.transparent,
                          closedElevation: 0,
                          // شكل الكارت قبل الفتح
                          closedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // الصفحة التي سيتم فتحها
                          openBuilder: (context, action) {
                            return ProductDetailView(manualProduct: product);
                            // ملاحظة: GetX سيتعامل مع Arguments تلقائياً لأننا سنمررها في closedBuilder
                          },
                          // الكارت الذي يراه المستخدم في القائمة
                          closedBuilder: (context, openContainer) {
                            return InkWell(
                              onTap: () {
                                // نمرر البيانات يدوياً قبل الفتح لضمان وصولها لـ ProductDetailView
                                // Get.arguments = product;
                                openContainer(); // تشغيل أنميشن الفتح
                              },
                              child: ProductCard(
                                index: index,
                                img: product.image.startsWith('http')
                                    ? product.image
                                    : "${AppLink.productsimages}/${product.image}",
                                title: product.title,
                                price:
                                    double.tryParse(product.price.toString()) ??
                                    0.0,
                                oldPrice:
                                    double.tryParse(
                                      product.originalPrice.toString(),
                                    ) ??
                                    0.0,
                                hash: product.blurHash.isEmpty
                                    ? r"UgIE@UoL~qtR%2ofS4WB%MofWCbGxuj[V@fQ"
                                    : product.blurHash, //Expected an identifier
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // ),
  // );
}

Widget _buildDrawer() {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.amber),
          child: Text(
            'Navigation',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        ListTile(
          leading: Icon(Icons.shopping_bag),
          title: Text('تعديل banner'),
          onTap: () {
            Get.back();
            Get.toNamed(AppRoutes.editBanScreen);
          },
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('تعديل المنتجات'),
          onTap: () {
            Get.back();
            Get.toNamed(AppRoutes.addscreen);
          },
        ),
        ListTile(
          leading: Icon(Icons.shopping_bag),
          title: Text('تعديل الكاتيجوري'),
          onTap: () {
            Get.back();
            Get.toNamed(AppRoutes.editCatScreen);
          },
        ),
        ListTile(
          leading: Icon(Icons.delivery_dining),
          title: Text('delivery'),
          onTap: () {
            Get.back();
            Get.toNamed(AppRoutes.deliHome);
          },
        ),
        ListTile(
          leading: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          title: Text(Get.isDarkMode ? "الوضع النهاري" : "الوضع الليلي"),
          onTap: () {
            ThemeService().switchTheme();
          },
        ),

        ListTile(
          leading: Icon(Icons.person),
          title: Text('البروفايل'),
          onTap: () {
            Get.back();
            Get.toNamed(AppRoutes.profile);
          },
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text('للتواصل'),
          onTap: () {
            Get.back();
            Get.toNamed(AppRoutes.mail);
          },
        ),
      ],
    ),
  );
}

Widget _buildCarouselBanner(TalabatController controller) {
  return Obx(() {
    if (controller.isBanLoading.value) {
      return const Center(child: LoadingCard(height: 150));
    }
    if (controller.banners.isEmpty) return const SizedBox();

    return PageView.builder(
      controller: controller.pageController,
      itemCount: controller.banners.length,
      onPageChanged: (index) => controller.currentBannerIndex.value = index,
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          key: ValueKey(controller.banners[index].image), // أضف هذا السطر

          imageUrl: controller.banners[index].image.startsWith('http')
              ? controller.banners[index].image
              : AppLink.bannersimages + controller.banners[index].image,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => const Icon(Icons.broken_image),
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(color: Colors.white),
          ),
        );
      },
    );
  });
}

Widget _buildCobon() {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.pink[50],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'عروض حصرية ',

                        style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Icon(Icons.flash_on, color: Colors.purple, size: 20),
                    ],
                  ),
                  Text(
                    'شاهد العروض الحصرية الان',
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(height: 40, width: 1, color: Colors.pink[200]),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'توصيل مجاني',
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.local_shipping, color: Colors.purple, size: 20),
                ],
              ),
              Text(
                'اشترى ب 114.00\$ اكثر لتحصل علي',
                style: TextStyle(color: Colors.purple[300], fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildSearchBar(TalabatController controller) {
  return Row(
    children: [
      Expanded(
        child: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: controller.isScrolled.value
                ? Text(
                    'طلبات',
                    key: ValueKey(1), // مفتاح ضروري للـ AnimatedSwitcher
                    style: GoogleFonts.lalezar(fontSize: 35),
                  )
                : Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6,
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.08),
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.camera_alt_outlined, size: 22),
                        SizedBox(width: 8),
                        Expanded(
                          child:
                              //  _buildSearchBbar(controller),
                              Text(
                                'ملابس رجالي و ستاتي',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.search, size: 22),
                        ),
                        Container(
                          width: 1,
                          height: 20,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Icon(
          Icons.favorite_border,
          size: 22,
          color: controller.isScrolled.value ? Colors.black : Colors.white,
        ),
      ),
      Obx(
        () => IconButton(
          onPressed: () => Get.toNamed(AppRoutes.cartPage),
          icon: Icon(
            Icons.shopping_cart_checkout_sharp,
            size: 24,
            color: controller.isScrolled.value
                ? Colors.black
                : Colors.white, // تغيير اللون لجذب الانتباه
          ),
        ),
      ),
    ],
  );
}
// }

// Widget _buildSearchBbar(TalabatController controller) {
//   return TextField(
//     // controller: _searchController,
//     decoration: InputDecoration(
//       hintText: "بحث...",
//       prefixIcon: const Icon(Icons.search),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//     ),
//     onChanged: (value) {
//       _filterProducts(value, controller);
//     },
//   );
// }

// void _filterProducts(String query, TalabatController controller) {
//   // تطبيق الفلترة على المنتجات حسب البحث
//   controller.productList.value =
//       controller.productList.value.where((product) {
//         final name = product.title.toLowerCase();
//         return name.contains(query.toLowerCase());
//       }).toList();
// }

class HomeCatItems extends StatelessWidget {
  final String img;
  final String title;
  final String id;
  final dynamic controller;

  const HomeCatItems({
    super.key,
    required this.img,
    required this.title,
    required this.controller,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // منطق الفلترة حسب القسم هنا
        Get.toNamed(AppRoutes.category, arguments: id);
      },
      child: Column(
        children: [
          // دائرة الصورة
          Expanded(
            child: Container(
              width: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(3),
              child: ClipOval(
                child: CachedNetworkImage(
                  key: ValueKey(img), // أضف هذا السطر

                  imageUrl: img,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.category_outlined),
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // اسم القسم
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
