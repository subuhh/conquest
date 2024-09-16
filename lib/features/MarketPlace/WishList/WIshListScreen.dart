import 'dart:developer';
import 'package:conquest/core/Controllers/Product_Controller/favorite_controller.dart';
import 'package:conquest/features/MarketPlace/Products/ProductCard/ProductCardLarge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/Shimmer/shimmer.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FavoriteController.instance;
    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
            )),
        backgroundColor: TColors.primary,
        title: Text(
          'WishList',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .apply(color: TColors.textWhite),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => FutureBuilder(
            future: controller.favoriteProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(
                  child: ListView.separated(
                    itemCount: 5, // Show 5 shimmer placeholders
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: TSizes.defaultSpace),
                    itemBuilder: (context, index) =>
                        TShimmer.singleContainer(60),
                  ),
                );
              } else if (snapshot.hasError) {
                log('Error: ${snapshot.error}');
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No WishList Found!'),
                );
              }

              final products = snapshot.data;

              return ListView.builder(
                itemCount: products!.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCardLarge(product: product);
                },
              );
            }),
      ),
    );
  }
}
