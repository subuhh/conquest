import 'package:conquest/core/Controllers/marketplace_controller.dart';
import 'package:conquest/core/Controllers/Product_Controller/product_controller.dart';
import 'package:conquest/features/AppBar/AppBar.dart';
import 'package:conquest/features/MarketPlace/Products_Widgets/cart_counter_icon.dart';
import 'package:conquest/features/MarketPlace/WishList/WIshListScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:conquest/common/widgets/searchbar.dart';
import 'package:conquest/features/MarketPlace/Carousel/carousel_section.dart';
import 'package:conquest/features/MarketPlace/Category/category_section.dart';
import 'package:conquest/features/MarketPlace/Products/Products_screen/products_section.dart';
import 'package:iconsax/iconsax.dart';
import '../../utils/constants/colors.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = ProductController.instance;
    final marketController = MarketplaceController.instance;

    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: CustomAppBar(
        left: 35,
        actions: [
          IconButton(
            onPressed: () => Get.to(() => WishListScreen()),
            icon: const Icon(Iconsax.heart),
          ),
          // Cart Button
          CartCounterIcon(),
          const SizedBox(width: 12)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Searchbar(),
            Expanded(
              child: SingleChildScrollView(
                child: Obx(
                  () {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Carousel Slider
                        CarouselSection(
                          isLoading: marketController.isLoading.value,
                          banners: marketController.banners,
                          //  banners: controller.banners,
                        ),

                        const SizedBox(height: 15),

                        // Category Buttons
                        CategorySection(
                          categories: marketController.categories,
                          isLoading: marketController.isLoading.value,
                        ),
                        const SizedBox(height: 2),

                        // Trending Section
                        if (productController.featuredProducts.isNotEmpty)
                          ProductsSection(
                            title: 'Trending Now',
                            isLoading: productController.isLoading.value,
                            products: productController.featuredProducts,
                          ),

                        // Bestseller Section
                        ProductsSection(
                          title: 'Bestseller',
                          isLoading: productController.isLoading.value,
                          products: productController.allProducts,
                        ),

                        SizedBox(height: 110)
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
