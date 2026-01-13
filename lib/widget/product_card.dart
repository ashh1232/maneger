import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // تأكد من إضافة الحزمة
import 'package:flutter_blurhash/flutter_blurhash.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.title,
    required this.index,
    required this.img,
    required this.price,
    required this.oldPrice,
    required this.hash,
  });

  final int index;
  final String img;
  final String title;
  final double price;
  final double oldPrice;
  final String hash;

  @override
  Widget build(BuildContext context) {
    return Card(
      // تقليل الـ elevation يحسن أداء التمرير في Impeller
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 180, maxHeight: 250),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              child: CachedNetworkImage(
                key: ValueKey(img), // أضف هذا السطر

                imageUrl: img,
                // height:
                //     180, // تحديد ارتفاع ثابت ضروري جداً لـ MasonryGrid لمنع الـ Layout shifts
                width: double.infinity,
                fit: BoxFit.cover,
                // استخدام ذاكرة التخزين المؤقت بذكاء (أهم سطر للأداء)
                memCacheWidth: 400,
                placeholder:
                    (context, url) => BlurHash(
                      // هذه السلسلة (hash) يجب أن تأتي من قاعدة البيانات مع رابط الصورة
                      hash: hash,

                      ///Undefined name 'f6ayS'.
                      imageFit: BoxFit.cover,
                    ),
                // (context, url) => Container(
                //   height: 180,
                //   color: Colors.grey[200],
                //   child: Shimmer.fromColors(
                //     baseColor: Colors.grey[300]!,
                //     highlightColor: Colors.grey[100]!,
                //     child: Container(color: Colors.red),
                //   ),
                // ),
                errorWidget:
                    (context, url, error) => Container(
                      height: 180,
                      color: Colors.grey[100],
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 30,
                          ),
                          Text(
                            "خطأ في الصورة",
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "\$${price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFA6338),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (oldPrice > price) // عرض السعر القديم فقط إذا كان أكبر
                      Text(
                        "\$${oldPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
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
