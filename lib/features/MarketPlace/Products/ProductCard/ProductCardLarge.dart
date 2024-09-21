import 'package:conquest/core/Controllers/Product_Controller/cart_controller.dart';
import 'package:conquest/core/Controllers/Product_Controller/favorite_controller.dart';
import 'package:conquest/features/MarketPlace/Cart/cart_screen.dart';
import 'package:conquest/features/MarketPlace/Products/Products_screen/product_detail.dart';
import 'package:conquest/features/MarketPlace/Products_Widgets/favorite_button.dart';
import 'package:conquest/utils/theme/customthemes/textThemes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/RoundedContainer.dart';
import '../../../../core/model/Product_Models/product.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class ProductCardLarge extends StatelessWidget {
  const ProductCardLarge({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final favoriteController = FavoriteController.instance;
    final cartController = CartController.instance;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItems / 2),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    product.thumbnail,
                    height: 120,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: ListTile(
                    //contentPadding: EdgeInsets.,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            product.title,
                            style: textTheme.titleSmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        FavoriteButton(productId: product.id),
                      ],
                    ),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: TSizes.spaceBtwItems / 2,
                        ),
                        buildPriceText(
                          originalPrice: double.parse(product.price),
                          discountedPrice: double.parse(product.salePrice),
                        ),
                        buildDiscountRibbon(
                          originalPrice: double.parse(product.price),
                          discountedPrice: double.parse(product.salePrice),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(height: 2, color: TColors.grey),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: TColors.grey, width: 1.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        'Buy Now',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: TSizes.spaceBtwItems,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      favoriteController.toggleFavoriteProduct(product.id);
                      if (product.productType == 'Single') {
                        final item =
                            cartController.convertToCartItem(product, 1);
                        cartController.addOneToCart(item);
                        Get.to(() => CartScreen());
                      } else {
                        Get.to(() => ProductDetail(productModel: product));
                      }
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: TColors.primary, width: 1.5),
                        borderRadius: BorderRadius.circular(5),
                        color: TColors.primary,
                      ),
                      child: Center(
                        child: Text(
                          'Move To Cart',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .apply(color: Colors.white),
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
    );
  }
}

class buildDiscountRibbon extends StatelessWidget {
  const buildDiscountRibbon({
    super.key,
    required this.originalPrice,
    required this.discountedPrice,
  });

  final double originalPrice;
  final double discountedPrice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RoundedContainer(
        radius: TSizes.sm,
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(
            horizontal: TSizes.sm, vertical: TSizes.xs),
        child: Text(
          '${((originalPrice - discountedPrice) / originalPrice * 100).toInt()}% OFF',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: TColors.white, fontSize: 12),
        ),
      ),
    );
  }
}

class buildPriceText extends StatelessWidget {
  const buildPriceText({
    super.key,
    required this.originalPrice,
    required this.discountedPrice,
  });

  final double originalPrice;
  final double discountedPrice;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '₹$discountedPrice',
          style: TTextTheme.lightTextTheme.headlineSmall,
        ),
        const SizedBox(width: 5),
        RichText(
          text: TextSpan(
            text: 'MRP ',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w400)
                .copyWith(
                  decoration: TextDecoration.lineThrough,
                  fontSize: 14,
                ),
            children: [
              TextSpan(
                text: '₹$originalPrice',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w400)
                    .copyWith(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 14,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
      ],
    );
  }
}
