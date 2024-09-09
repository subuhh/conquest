import 'package:conquest/features/screens/MarketPlace/Products/products_widgets/productCard.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/model/product.dart';

class ProductsSection extends StatefulWidget {
  final String title;
  final bool isLoading;
  final List<ProductModel> products;
  const ProductsSection({
    super.key,
    required this.title,
    required this.isLoading,
    required this.products,
  });

  @override
  State<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends State<ProductsSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          // Section Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('See All'),
              ),
            ],
          ),
          widget.isLoading
              ? SizedBox(
                  height: 300, // Adjust this height based on the item size
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4, // Show a few shimmer items
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.475,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: _buildShimmerProductCard(),
                        ),
                      );
                    },
                  ),
                )
              : SizedBox(
                  height: 300, // Adjust this height based on the item size
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.products.length,
                    itemBuilder: (context, index) {
                      final product = widget.products[index];
                      final imageUrl = product.images[0];
                      return SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.475, // Adjust width based on your requirement
                        //margin: EdgeInsets.symmetric(horizontal: 10.0), // Add some spacing between items
                        child: ProductCard(
                          imageUrl: imageUrl,
                          title: product.name,
                          oldPrice: '${product.originalPrice}',
                          newPrice: '${product.discountedPrice}',
                          productModel: product,
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildShimmerProductCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 15,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  // Shimmer for the "Add to Cart" button
                  height: 35,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
