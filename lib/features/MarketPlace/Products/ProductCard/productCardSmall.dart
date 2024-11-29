import 'package:cached_network_image/cached_network_image.dart';
import 'package:conquest/core/Controllers/Product_Controller/cart_controller.dart';
import 'package:conquest/core/model/Product_Models/product.dart';
import 'package:conquest/features/MarketPlace/Cart/cart_screen.dart';
import 'package:conquest/features/MarketPlace/Products/Products_screen/product_detail.dart';
import 'package:conquest/features/MarketPlace/Products_Widgets/favorite_button.dart';
import 'package:conquest/utils/Loading/error_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/pricing_calculator.dart';
import '../../../../utils/theme/customthemes/textThemes.dart';

class ProductCardSmall extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String oldPrice;
  final String newPrice;
  final ProductModel productModel;

  const ProductCardSmall({
    required this.imageUrl,
    required this.title,
    required this.oldPrice,
    required this.newPrice,
    super.key,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;

    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetail(productModel: productModel));
      },
      child: Card(
        color: Colors.white,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  children: [
                    _buildProductImage(constraints.maxWidth),
                    _buildDiscountRibbon(),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: FavoriteButton(productId: productModel.id),
                    )
                  ],
                ),
                _buildProductDetails(
                    context, constraints.maxHeight - 165, controller),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductImage(double maxWidth) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: 165,
        width: maxWidth,
        fit: BoxFit.fitWidth,
        errorWidget: (context, error, stackTrace) => ImageLoading.errorImage(),
      ),
    );
  }

  Widget _buildProductDetails(
      BuildContext context, double maxHeight, CartController controller) {
    return SizedBox(
      height: maxHeight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProductTitle(context),
            const SizedBox(height: 8),
            _buildPriceRow(context),
            const SizedBox(height: 8),
            _buildAddToCartButton(context, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildProductTitle(context) {
    return Text(
      title,
      style: TTextTheme.lightTextTheme.bodyMedium,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceRow(context) {
    final discountAmount = double.parse(newPrice) * 0.05;
    final premiumPrice = (double.parse(newPrice) - discountAmount).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RichText(
              text: TextSpan(
                text: '₹$newPrice  ',
                style: TTextTheme.lightTextTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: '₹$oldPrice',
                    style: TTextTheme.lightTextTheme.titleMedium!.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '₹$premiumPrice ',
              style: TTextTheme.lightTextTheme.labelLarge!.copyWith(
                color: Colors.black,
              ),
            ),
            Text(
              'With ',
              style: TTextTheme.lightTextTheme.labelLarge!.copyWith(
                color: TColors.primary,
              ),
            ),
            SvgPicture.asset(
              'assets/icons/appicons/premiumicon.svg',
              height: 20,
              colorFilter:
                  const ColorFilter.mode(TColors.primary, BlendMode.srcIn),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(
      BuildContext context, CartController controller) {
    return Obx(() {
      final productQuantityInCart =
          controller.getProductQuantityInCart(productModel.id);
      return GestureDetector(
        onTap: () {
          if (productQuantityInCart > 0) {
            Get.to(() => CartScreen());
          } else if (productModel.productType == 'Single') {
            final cartItem = controller.convertToCartItem(productModel, 1);
            controller.addOneToCart(cartItem);
            // controller.addToCart(widget.productModel);
          } else {
            Get.to(() => ProductDetail(productModel: productModel));
          }
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: productQuantityInCart > 0 ? TColors.primary : TColors.black,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Center(
            child: Text(
              productQuantityInCart > 0 ? 'Go to Cart' : 'Add to Cart',
              style: TextStyle(
                color: productQuantityInCart > 0 ? TColors.white : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDiscountRibbon() {
    int discountPercentage = TPricingCalculator.calculateDiscountPercentage(
        int.parse(oldPrice), int.parse(newPrice));

    return Positioned(
      top: 10,
      left: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: TColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '$discountPercentage% OFF',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
