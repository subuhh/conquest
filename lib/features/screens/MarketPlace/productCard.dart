import 'package:conquest/features/utils/constants/colors.dart';
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
    Key? key,
  }) : super(key: key);


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
              child: _buildWhishlistbutton())
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
              children:[
            _buildAddToCartButton(context)] ),
        ],
      ),
    );
  }

  Widget _buildProductTitle(context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceRow(context) {
    return Row(
      children: [
        Text(
          '₹${oldPrice}',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(decoration: TextDecoration.lineThrough,color: Colors.grey),
        ),
        const SizedBox(width: 10),
        Text(
          '₹${newPrice}',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.green),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return ElevatedButton(
      style:
      ElevatedButton.styleFrom(
        backgroundColor: TColors.primary,
        foregroundColor: TColors.primary,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.transparent, width: 0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      ),
      onPressed: () {
        // Add to cart logic here
      },
      child: const Text(
        'Add to Cart',
        style: TextStyle(color: Colors.white),
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

Widget _buildWhishlistbutton(){
  bool itemInWhisList = false;
   return Container(
    height: 40,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.grey.shade300,
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