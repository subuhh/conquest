import 'dart:developer';
import 'package:conquest/core/Controllers/Product_Controller/favorite_controller.dart';
import 'package:conquest/features/MarketPlace/Products/ProductCard/ProductCardLarge.dart';
import 'package:conquest/utils/Animation_Loaders/TAnimation_Page.dart';
import 'package:conquest/utils/constants/colors.dart';
import 'package:conquest/utils/theme/customthemes/textThemes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/Shimmer/shimmer.dart';
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
            size: 26,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: TColors.primary,
        title: Text(
          'WishList',
          style:
              TTextTheme.lightTextTheme.titleMedium!.apply(color: Colors.white),
        ),
      ),
      body: Obx(() {
        // If there are no favorite products
        if (controller.favorites.isEmpty) {
          return TAnimationPage(
            asset: 'assets/animation/empty_cart.json',
            height: 350,
            width: 350,
            titleText: 'Whoops! Wishlist is Empty...',
            buttonText: 'Lets add some',
            onPressed: () => Get.back(),
          );
        }

        return FutureBuilder(
          future: controller.favoriteProducts(), // Fetch products
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.separated(
                  itemCount: 4, // Show shimmer placeholders
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: TSizes.defaultSpace),
                  itemBuilder: (context, index) =>
                      TShimmer.singleContainer(180),
                ),
              );
            } else if (snapshot.hasError) {
              log('Error: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return TAnimationPage(
                asset: 'assets/animation/empty_cart.json',
                height: 350,
                width: 350,
                titleText: 'Whoops! Wishlist is Empty...',
                buttonText: 'Lets add some',
                onPressed: () => Get.back(),
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
          },
        );
      }),
    );
  }
}
