import 'package:conquest/core/model/Product_Models/product.dart';
import 'package:conquest/features/MarketPlace/Products/Products_screen/product_detail.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/theme/customthemes/textThemes.dart';
import '../products_widgets/wishlist_widget.dart';

class ProductCardSmall extends StatefulWidget {
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
  State<ProductCardSmall> createState() => _ProductCardSmallState();
}

class _ProductCardSmallState extends State<ProductCardSmall> {
  bool itemInWishList = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(
              productModel: widget.productModel,
            ),
          ),
        );
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
                      right: 5,
                      top: 5,
                      child: WishListButton(),
                    )
                  ],
                ),
                _buildProductDetails(context, constraints.maxHeight - 160),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductImage(double maxWidth) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      child: Image.network(
        widget.imageUrl,
        height: 160,
        width: maxWidth,
        fit: BoxFit.fitWidth,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context, double maxHeight) {
    return SizedBox(
      height: maxHeight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProductTitle(context),
            //const SizedBox(height: 6),
            _buildPriceRow(context),
            const SizedBox(height: TSizes.spaceBtwItems / 2),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAddToCartButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductTitle(context) {
    return Text(
      widget.title,
      style: TTextTheme.lightTextTheme.bodyMedium,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceRow(context) {
    final discountAmount = double.parse(widget.newPrice) * 0.05;
    final premiumPrice =
        (double.parse(widget.newPrice) - discountAmount).toStringAsFixed(2);
    return Column(
      children: [
        Row(
          children: [
            RichText(
              text: TextSpan(
                text: '₹${widget.newPrice}  ',
                style: TTextTheme.lightTextTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: '₹${widget.oldPrice}',
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
        //const SizedBox(height: 4),
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

  Widget _buildAddToCartButton(BuildContext context) {
    return SizedBox(
      height: 35,
      width: 110,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {},
        child: const Text(
          'Add to Cart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountRibbon() {
    return Positioned(
      top: 10,
      left: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: TColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          '20% OFF',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // Widget _buildWishlistButton() {
  //   return Container(
  //     height: 35,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       shape: BoxShape.circle,
  //       border: Border.all(
  //         color: Colors.grey.shade400,
  //       ),
  //     ),
  //     child: Center(
  //       child: IconButton(
  //         icon: Icon(
  //           itemInWishList ? Icons.favorite : Icons.favorite_border,
  //           color: itemInWishList ? Colors.redAccent : Colors.black,
  //           size: 20,
  //         ),
  //         onPressed: () {
  //           setState(() {
  //             itemInWishList = !itemInWishList;
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }
}
