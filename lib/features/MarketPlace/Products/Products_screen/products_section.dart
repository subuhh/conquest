import 'package:conquest/features/MarketPlace/Products/ProductCard/productCardSmall.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/model/Product_Models/product.dart';
import '../../../../utils/theme/customthemes/textThemes.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Column(
        children: [
          // Section Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title,
                  style: Theme.of(context).textTheme.titleMedium),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: TTextTheme.lightTextTheme.titleMedium!
                      .copyWith(color: Colors.green),
                ),
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
                  height: 320, // Adjust this height based on the item size
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.products.length,
                    itemBuilder: (context, index) {
                      final product = widget.products[index];
                      final imageUrl = product.thumbnail;
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.475,
                        child: ProductCardSmall(
                          imageUrl: imageUrl,
                          title: product.title,
                          oldPrice: '${product.price}',
                          newPrice: '${product.salePrice}',
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
