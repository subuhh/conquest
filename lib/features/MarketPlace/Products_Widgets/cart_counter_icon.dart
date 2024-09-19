import 'package:conquest/core/Controllers/Product_Controller/cart_controller.dart';
import 'package:conquest/utils/theme/customthemes/textThemes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CartCounterIcon extends StatelessWidget {
  const CartCounterIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());

    return Stack(
      children: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/cart'),
          icon: const Icon(Iconsax.shopping_cart),
        ),
        // if (controller.noOfCartItems.value > 0)
        Positioned(
          right: 0,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Obx(
                () => Text(
                  controller.noOfCartItems.value.toString(),
                  style: TTextTheme.lightTextTheme.labelLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
