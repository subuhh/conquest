import 'dart:math';
import 'package:conquest/features/MarketPlace/Products/ProductCard/productCardSmall.dart';
import 'package:conquest/utils/Loading/shimmer_loading.dart';
import 'package:flutter/material.dart';
import '../../../../core/model/Product_Models/product.dart';
import '../../../../utils/theme/customthemes/textThemes.dart';
import 'package:get/get.dart';

import '../Products_See_All_Screen/products_see_all_screen.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        children: [
          // Section Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(" ${widget.title}",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              TextButton(
                onPressed: () {
                  Get.to(
                        () => ProductsSeeAllScreen(
                      products: widget.products,
                      name: widget.title,
                    ),
                  );
                },
                child: Text(
                  'See All',
                  style: TTextTheme.lightTextTheme.titleMedium!
                      .copyWith(color: Colors.green),
                ),
              ),
            ],
          ),
          widget.isLoading
              ? ShimmerLoading.shimmerListView()
              : SizedBox(
                  height: 320, // Adjust this height based on the item size
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: min(widget.products.length, 6),
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
}
