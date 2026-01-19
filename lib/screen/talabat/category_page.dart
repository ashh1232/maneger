import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maneger/class/handlingdataview.dart';
import 'package:maneger/controller/shein_controller.dart';
import 'package:maneger/core/constants/api_constants.dart';
import 'package:maneger/linkapi.dart';
import 'package:maneger/routes.dart';
import 'package:shimmer/shimmer.dart';

class CategoryPage extends GetView<CategoryController> {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFFFF0F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('طلبات', style: GoogleFonts.lalezar(fontSize: 28)),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          // Hero Carousel Banner
          SliverToBoxAdapter(
            child: SizedBox(
              height: 280,
              child: Obx(
                () => Stack(
                  children: [
                    PageView.builder(
                      controller: controller.bannerController,
                      onPageChanged: controller.onBannerPageChanged,
                      itemCount: controller.banner.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          key: ValueKey(
                            controller.banner[index].image,
                          ), // أضف هذا السطر

                          imageUrl:
                              controller.banner[index].image.startsWith('http')
                              ? controller.banner[index].image
                              : ApiConstants.bannersImages +
                                    controller.banner[index].image,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.broken_image),
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(color: Colors.white),
                          ),
                        );
                      },
                    ),
                    // Dot Indicators
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(controller.banner.length, (
                            index,
                          ) {
                            final isActive =
                                controller.currentBannerIndex.value == index;
                            return ScaleTransition(
                              scale: isActive
                                  ? Tween<double>(
                                      begin: 1.0,
                                      end: 1.3,
                                    ).animate(controller.dotAnimController)
                                  : AlwaysStoppedAnimation(1.0),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                width: isActive ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Colors.white
                                      // ignore: deprecated_member_use
                                      : Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Title Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      // controller.productList[0].title,
                      controller.name.value,
                      // 'Women\'s & Men\'s Clothing',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Shop Online Fashion',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          // Category Chips
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Women', 'Men', 'Kids', 'Curve', 'Home']
                      .map(
                        (category) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Chip(
                            label: Handlingdataview(
                              statusRequest: controller.statusRequest.value,

                              widget: Text(
                                category,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            // ignore: deprecated_member_use
                            backgroundColor: Colors.white.withOpacity(0.8),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),

          // Featured Products Grid
          Obx(
            () => SliverPadding(
              padding: EdgeInsets.all(12),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final imageUrl =
                      controller.productList[index].image.startsWith('http')
                      ? controller.productList[index].image
                      : ApiConstants.productsImages +
                            controller.productList[index].image;
                  return InkWell(
                    onTap: () => Get.toNamed(
                      AppRoutes.productDetail,
                      arguments: controller.productList[index],
                    ),

                    child: _buildProductCard(imageUrl, index),
                  );
                }, childCount: controller.productList.length),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String imageUrl, int index) {
    final titles = controller.productList[index].title;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 32,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titles,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '\$${double.tryParse(controller.productList[index].price.toString()) ?? 0.0} ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFA6338),
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${(double.tryParse(controller.productList[index].originalPrice.toString()) ?? '')}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
