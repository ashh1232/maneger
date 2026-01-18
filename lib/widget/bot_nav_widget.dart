import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maneger/model/product_model.dart';

class BotNavWidget extends StatelessWidget {
  const BotNavWidget({
    super.key,
    required this.pro,
    required this.controller,
    this.isIcon = true,
    required this.onPressed,
    required this.updateProductImage,
  });
  final Function() onPressed;
  final Product pro;
  final String updateProductImage;
  final bool isIcon;
  final controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      width: double.infinity,
      height: 55,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              onPressed: onPressed,
              child: Text(
                updateProductImage,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 5),
          if (isIcon)
            Obx(
              () => IconButton(
                icon: Icon(
                  controller.isFavorite.value
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 30,
                ),
                onPressed: () => controller.toggleFavorite(),
              ),
            ),
        ],
      ),
    );
  }
}
