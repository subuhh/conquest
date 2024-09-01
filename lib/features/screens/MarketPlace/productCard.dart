import 'package:conquest/features/utils/constants/colors.dart';
import 'package:conquest/features/utils/theme/customthemes/textThemes.dart';
import 'package:flutter/material.dart';

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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProductTitle(context),
            const SizedBox(height: 6),
            _buildPriceRow(context),
            const Spacer(),
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
        style: TTextTheme.lightTextTheme.headlineSmall,
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
                style: TTextTheme.lightTextTheme.headlineSmall!.copyWith(
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
            RichText(
              text: TextSpan(
                text: '₹$premiumPrice ',
                style: TTextTheme.lightTextTheme.headlineSmall!.copyWith(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'With Pro',
                    style: TTextTheme.lightTextTheme.titleLarge!.copyWith(
                      color: TColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: TColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        // Add to cart logic here
      },
      child: const Text(
        'Add to Cart',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
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
