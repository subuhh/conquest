import 'package:conquest/core/model/Product_Models/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';
import '../../../core/Controllers/Product_Controller/cart_controller.dart';

class BottomAddToCartWidget extends StatelessWidget {
  const BottomAddToCartWidget({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                //padding: const EdgeInsets.all(TSizes.sm),
                backgroundColor: TColors.white,
                side: const BorderSide(color: TColors.white, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: Text(
                'Buy Now',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          Obx(
            () => Expanded(
              child: ElevatedButton(
                onPressed: controller.productQuantityInCart.value < 1
                    ? null
                    : () => controller.addToCart(product),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  //padding: const EdgeInsets.all(TSizes.sm),
                  backgroundColor: TColors.primary,
                  side: const BorderSide(color: TColors.primary),
                ),
                child: Text(
                  'Add to Cart',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: TColors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
