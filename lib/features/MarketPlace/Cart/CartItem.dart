import 'dart:developer';
import 'package:conquest/core/Controllers/Product_Controller/cart_controller.dart';
import 'package:conquest/core/Controllers/Product_Controller/favorite_controller.dart';
import 'package:conquest/core/model/product_models/cart_item.dart';
import 'package:conquest/core/repository/product_repository.dart';
import 'package:conquest/features/MarketPlace/Products/Products_screen/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../common/widgets/RoundedContainer.dart';
import '../../../common/widgets/product_price_text.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/theme/customthemes/textThemes.dart';

class CartItem extends StatelessWidget {
  CartItem({
    super.key,
    required this.cartItem,
    required this.index,
  });

  final CartItemModel cartItem;
  final int index;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controller = CartController.instance;
    final wishListController = FavoriteController.instance;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems / 3),
      child: InkWell(
        onTap: () async {
          final productModel = await ProductRepository.instance.getProductById(cartItem.productId);
          Get.to(() => ProductDetail(productModel: productModel!));
        },
        child: Card(
          elevation: 0.25,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      cartItem.image!,
                      height: 100,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                cartItem.title,
                                style: textTheme.titleMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                controller.removeCartItem(index, cartItem);
                              },
                              icon: SvgPicture.asset(
                                'assets/icons/drawerIcons/delete.svg',
                                colorFilter: ColorFilter.mode(
                                    TColors.grey, BlendMode.srcIn),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // if (cartItem.selectedVariation != null)
                            Text.rich(
                              TextSpan(
                                children: (cartItem.selectedVariation ?? {})
                                    .entries
                                    .map(
                                      (e) => TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${e.value} ',
                                            style: textTheme.titleSmall,
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            Row(
                              children: [
                                ProductPriceText(price: '${cartItem.price}'),
                                const SizedBox(width: 5),
                                Text(
                                  ' ₹${cartItem.price}',
                                  style: TTextTheme.lightTextTheme.titleLarge!
                                      .copyWith(fontWeight: FontWeight.w400)
                                      .apply(
                                          decoration:
                                              TextDecoration.lineThrough),
                                ),
                                const SizedBox(width: 5),
                                RoundedContainer(
                                  radius: TSizes.sm,
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: TSizes.sm,
                                    vertical: TSizes.xs,
                                  ),
                                  child: Text(
                                    '20% OFF',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .apply(color: TColors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(height: 2, color: TColors.grey),
                SizedBox(height: TSizes.spaceBtwItems),
                Row(
                  children: [
                    // Quantity Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: TColors.primary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0),
                            ),
                            border: Border.all(
                              color: TColors.primary,
                              width: 1.0,
                            ),
                          ),
                          width: 30,
                          height: 25,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Iconsax.minus,
                              color: TColors.white,
                            ),
                            onPressed: () =>
                                controller.removeOneToCart(cartItem),
                          ),
                        ),

                        // Quantity box
                        Container(
                          width: 30,
                          height: 25,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: TColors.white,
                            border: Border.symmetric(
                              horizontal: BorderSide(
                                color: TColors.grey,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Text(
                            '${cartItem.quantity}', // Quantity number
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),

                        // Plus button
                        Container(
                          decoration: BoxDecoration(
                            color: TColors.primary,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                            ),
                            border: Border.all(
                              color: TColors.primary,
                              width: 1.0,
                            ),
                          ),
                          width: 30,
                          height: 25,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Iconsax.add,
                              color: TColors.white,
                            ),
                            onPressed: () => controller.addOneToCart(cartItem),
                          ),
                        )
                      ],
                    ),

                    // Move To WishList Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          log('Favorite Variation Id: ${cartItem.variationId}');
                          wishListController.showMoveToFavoriteDialog(cartItem);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.spaceBtwItems),
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: TColors.grey, width: 1.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                'Move To WishList',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
