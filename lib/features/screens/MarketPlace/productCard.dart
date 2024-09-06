import 'package:conquest/features/shop/screens/product-details/product_detail.dart';
import 'package:conquest/features/utils/constants/colors.dart';
import 'package:conquest/features/utils/theme/customthemes/textThemes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'ProductPage/ProductPage.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String oldPrice;
  final String newPrice;

  const ProductCard({
    required this.imageUrl,
    required this.title,
    required this.oldPrice,
    required this.newPrice,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ProductDetail()));
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                      child: _buildWishlistButton(),
                    )
                  ],
                ),
                _buildProductDetails(context, constraints.maxHeight - 150),
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
        imageUrl,
        height: 150,
        width: maxWidth,
        fit: BoxFit.cover,
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
            //const Spacer(),
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
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        title,
        style: TTextTheme.lightTextTheme.bodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPriceRow(context) {
    final discountAmount = double.parse(newPrice) * 0.05;
    final premiumPrice =
    (double.parse(newPrice) - discountAmount).toStringAsFixed(2);
    return Column(
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
              'assets/icons/appicons/premiumicon.svg', height: 20,
              color: TColors.primary,
            )


          ],
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: TColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {

        },
        child: const Text(
          'Add to Cart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
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
          color: Colors.redAccent,
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
}

Widget _buildWishlistButton() {
  bool itemInWishList = false;
  return Container(
    height: 40,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.grey.shade400,
      ),
    ),
    child: Center(
      child: IconButton(
        icon: Icon(
          itemInWishList ? Icons.favorite : Icons.favorite_border,
          color: itemInWishList ? Colors.redAccent : Colors.black,
        ),
        onPressed: () {},
      ),
    ),
  );
}
