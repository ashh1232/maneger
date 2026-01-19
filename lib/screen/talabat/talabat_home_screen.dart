import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/features/products/presentation/controllers/product_controller_clean.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/routes.dart';
import 'package:maneger/screen/talabat/product_detail_view.dart';
import 'package:maneger/service/theme_service.dart';
import 'package:maneger/widget/loading_card.dart';
import 'package:maneger/widget/product_card.dart';
import 'package:shimmer/shimmer.dart';

class TalabatHomeScreen extends StatelessWidget {
  TalabatHomeScreen({super.key});

  // Use ProductControllerClean instead of TalabatController
  final ProductControllerClean controller = Get.find<ProductControllerClean>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification.depth == 0 &&
              notification is ScrollUpdateNotification) {
            bool isOverThreshold = notification.metrics.pixels > 50;
            if (isOverThreshold != controller.isScrolled.value) {
              controller.toggleScroll(isOverThreshold);
            }
          }
          return false;
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
                controller.refreshAll();
              },
            ),
            SliverAppBar(
              surfaceTintColor: Theme.of(context).colorScheme.surface,
              pinned: true,
              stretch: true,
              floating: false,
              expandedHeight: 220,
              elevation: 0,
              title: SizedBox(height: 35, child: _buildSearchBar(controller)),
              actions: [],
              flexibleSpace: FlexibleSpaceBar(
                background: _buildCarouselBanner(controller),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10),
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(500),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7),
                height: 50,
                child: _buildCobon(),
              ),
            ),
            SliverToBoxAdapter(
              child: Obx(
                () => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  height: 180,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 5,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: controller.isCategoryLoading.value
                        ? 10
                        : controller.categories.length,
                    itemBuilder: (context, index) {
                      if (controller.isCategoryLoading.value) {
                        return const LoadingCard(height: 20);
                      }

                      final cat = controller.categories[index];
                      // Handle both full URLs and relative paths
                      final imageUrl = cat.imageUrl.startsWith('http')
                          ? cat.imageUrl
                          : "${ApiConstants.categoriesImages}/${cat.imageUrl}";

                      return HomeCatItems(
                        img: imageUrl,
                        title: cat.title,
                        controller: controller,
                        id: cat.id,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            Obx(() {
              double screenWidth = MediaQuery.of(context).size.width;
              int crossAxisCount = screenWidth > 600 ? 4 : 2;

              return SliverPadding(
                padding: EdgeInsetsGeometry.all(5),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 5,
                  childCount:
                      controller.isLoading.value && controller.products.isEmpty
                      ? 9
                      : controller.products.length +
                            (controller.hasMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Loading indicator at bottom
                    if (index == controller.products.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: LoadingCard(height: 180),
                        ),
                      );
                    }

                    // Initial loading
                    if (controller.products.isEmpty &&
                        controller.isLoading.value) {
                      return const LoadingCard(height: 150);
                    } else {
                      final product = controller.products[index];

                      // Construct image URL
                      final imageUrl = product.imageUrl.startsWith('http')
                          ? product.imageUrl
                          : "${ApiConstants.productsImages}/${product.imageUrl}";

                      // Get blurHash
                      final blurHash =
                          (product.blurHash != null &&
                              product.blurHash!.isNotEmpty)
                          ? product.blurHash!
                          : r"UgIE@UoL~qtR%2ofS4WB%MofWCbGxuj[V@fQ";

                      return OpenContainer(
                        transitionDuration: const Duration(milliseconds: 500),
                        openColor: Colors.white,
                        closedColor: Colors.transparent,
                        closedElevation: 0,
                        closedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        openBuilder: (context, action) {
                          // Pass new Product entity to updated DetailView
                          return ProductDetailView(manualProduct: product);
                        },
                        closedBuilder: (context, openContainer) {
                          return InkWell(
                            onTap: () {
                              openContainer();
                            },
                            child: ProductCard(
                              index: index,
                              img: imageUrl,
                              title: product.title,
                              price: product.price, // Double
                              oldPrice: product.originalPrice, // Double
                              hash: blurHash,
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
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

Widget _buildCarouselBanner(ProductControllerClean controller) {
  return Obx(() {
    if (controller.isBannerLoading.value || controller.banners.isEmpty) {
      return const LoadingCard(height: 220);
    }

    return Stack(
      children: [
        PageView.builder(
          physics: const ClampingScrollPhysics(),
          allowImplicitScrolling: true,
          controller: controller.pageController,
          itemCount: controller.banners.length,
          onPageChanged: (index) => controller.setBannerIndex(index),
          itemBuilder: (context, index) {
            final banner = controller.banners[index];
            final imageUrl = banner.imageUrl.startsWith('http')
                ? banner.imageUrl
                : "${ApiConstants.bannersImages}/${banner.imageUrl}";

            return CachedNetworkImage(
              key: ValueKey(banner.id),
              imageUrl: imageUrl,
              fit: BoxFit.cover,
            );
          },
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black26,
                  Colors.transparent,
                  Colors.transparent,
                ],
                stops: [0.0, 0.3, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  });
}

Widget _buildCobon() {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 3),
    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 1),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 247, 244, 221),
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
                          color: const Color.fromARGB(255, 66, 16, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      Icon(
                        Icons.flash_on,
                        color: const Color.fromARGB(255, 66, 16, 0),
                        size: 15,
                      ),
                    ],
                  ),
                  Text(
                    'شاهد العروض الحصرية الان',
                    style: TextStyle(color: Colors.grey, fontSize: 9),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 30,
          width: 0.5,
          color: const Color.fromARGB(255, 128, 31, 1),
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'توصيل مجاني',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 66, 16, 0),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.local_shipping,
                    color: const Color.fromARGB(255, 66, 16, 0),
                    size: 15,
                  ),
                ],
              ),
              Text(
                'اشترى ب 114.00\$ اكثر لتحصل علي',
                style: TextStyle(color: Colors.grey, fontSize: 9),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildSearchBar(ProductControllerClean controller) {
  return Row(
    children: [
      Expanded(
        child: Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 900),
            padding: EdgeInsets.symmetric(
              horizontal: controller.isScrolled.value ? 20 : 0,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: controller.isScrolled.value
                  ? Container(
                      height: 36,
                      alignment: Alignment.centerRight,
                      child: Text(
                        'طلبات',
                        key: const ValueKey(1),
                        style: GoogleFonts.lalezar(fontSize: 28),
                      ),
                    )
                  : Container(
                      height: 36,
                      key: const ValueKey(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
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
                            child: Text(
                              'ملابس رجالي و ستاتي',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            height: 30,
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(1),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(
                                Icons.search,
                                size: 22,
                                color: Colors.white,
                              ),
                            ),
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
      ),
      Obx(
        () => InkWell(
          onTap: () => Get.toNamed(AppRoutes.favorite),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.favorite_border,
              size: 22,
              color: controller.isScrolled.value ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
      Obx(
        () => IconButton(
          onPressed: () => Get.toNamed(AppRoutes.cartPage),
          icon: Icon(
            Icons.shopping_cart_checkout_sharp,
            size: 24,
            color: controller.isScrolled.value ? Colors.black : Colors.white,
          ),
        ),
      ),
    ],
  );
}

class HomeCatItems extends StatelessWidget {
  final String img;
  final String title;
  final String id;
  final ProductControllerClean controller;

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
        Get.toNamed(AppRoutes.category, arguments: id);
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(3),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(19),
                child: CachedNetworkImage(
                  key: ValueKey(img),
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
