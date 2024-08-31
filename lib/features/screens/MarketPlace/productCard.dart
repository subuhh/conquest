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
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(),
              _buildProductDetails(context),
            ],
          ),
          _buildDiscountRibbon(),
          Positioned(
            right: 5,
            top: 5,
            child: _buildWhishlistbutton(),
          )
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      child: Image.network(
        imageUrl,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductTitle(context),
          const SizedBox(height: 6),
          _buildPriceRow(context),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAddToCartButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductTitle(context) {
    return Text(
      title,
      style: TTextTheme.lightTextTheme.headlineMedium,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
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
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                children: [
                  TextSpan(
                    text: '₹$oldPrice',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            RichText(
              text: TextSpan(
                text: '₹$premiumPrice ',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                children: [
                  TextSpan(
                    text: 'With Pro',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: TColors.primary,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
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
          fontSize: 17,
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

Widget _buildWhishlistbutton() {
  bool itemInWhisList = false;
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
          itemInWhisList ? Icons.favorite : Icons.favorite_border,
          color: itemInWhisList ? Colors.redAccent : Colors.black,
        ),
        onPressed: () {},
      ),
    ),
  );
}
