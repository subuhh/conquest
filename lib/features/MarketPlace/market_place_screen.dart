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
import '../../utils/constants/sizes.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controllerP = Get.put(ProductController());
    final controller = Get.put(MarketplaceController());

    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: CustomAppBar(actions: [
        IconButton(
          onPressed: () => Get.to(() => WishListScreen()),
          icon: const Icon(Iconsax.heart),
        ),
        // Cart Button
        CartCounterIcon(),
        const SizedBox(width: 12)
      ],),
      body: Column(
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
                        isLoading: controller.isLoading.value,
                        banners: controller.banners,
                        //  banners: controller.banners,
                      ),

                      // Category Buttons
                      CategorySection(
                        categories: controller.categories,
                        isLoading: controller.isLoading.value,
                      ),

                      // Trending Section
                      if (controllerP.featuredProducts.isNotEmpty)
                        ProductsSection(
                          title: 'Trending Now',
                          isLoading: controllerP.isLoading.value,
                          products: controllerP.featuredProducts,
                        ),

                      // Bestseller Section
                      ProductsSection(
                        title: 'Bestseller',
                        isLoading: controllerP.isLoading.value,
                        products: controllerP.allProducts,
                      ),

                      // Top Picks Section
                      // ProductsSection(
                      //   title: 'Top Picks',
                      //   isLoading: controller.isLoading.value,
                      //   products: controller.products,
                      // ),
                      SizedBox(
                        height: 110,
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
