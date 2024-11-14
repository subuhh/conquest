import 'package:conquest/core/Controllers/Product_Controller/cart_controller.dart';
import 'package:conquest/utils/theme/customthemes/textThemes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CartCounterIcon extends StatelessWidget {
  const CartCounterIcon({super.key, this.isDecorated = false});
  final bool isDecorated;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());

    return Stack(
      children: [
        IconButton(
          onPressed: () => Get.toNamed('/cart'),
          icon: Icon(
            Iconsax.shopping_cart,
            color: isDecorated ? Colors.white : null,
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
            width: isDecorated ? 16 : 18,
            height: isDecorated ? 16 : 18,
            decoration: BoxDecoration(
              color: isDecorated ? Colors.white : Colors.red,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Obx(
                () => Text(
                  controller.noOfCartItems.value.toString(),
                  style: TTextTheme.lightTextTheme.labelLarge!.copyWith(
                    color: isDecorated ? Colors.red : Colors.white,
                    fontWeight: isDecorated ? FontWeight.w700 : FontWeight.w500,
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
