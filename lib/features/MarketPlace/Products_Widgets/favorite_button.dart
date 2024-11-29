import 'package:conquest/core/Controllers/Product_Controller/favorite_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';

class FavoriteButton extends StatelessWidget {
  final bool isDecoration;
  final String productId;
  const FavoriteButton(
      {super.key, this.isDecoration = true, required this.productId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoriteController());

    return Obx(() {
      return Container(
        height: isDecoration ? 35 : null,
        decoration: isDecoration
            ? BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
              )
            : null,
        child: Center(
          child: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Icon(
                controller.isFavorite(productId)
                    ? Iconsax.heart5
                    : Iconsax.heart,
                color: controller.isFavorite(productId)
                    ? isDecoration
                        ? TColors.primary
                        : Colors.white
                    : isDecoration
                        ? Colors.black
                        : Colors.white,
                size: isDecoration ? 19 : null,
              ),
            ),
            onTap: () => controller.toggleFavoriteProduct(productId),
          ),
        ),
      );
    });
  }
}
