import 'package:conquest/core/Controllers/marketplace_controller.dart';
import 'package:conquest/core/Controllers/Product_Controller/product_controller.dart';
import 'package:conquest/features/MarketPlace/WishList/WIshListScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:conquest/common/widgets/searchbar.dart';
import 'package:conquest/features/MarketPlace/Carousel/carousel_section.dart';
import 'package:conquest/features/MarketPlace/Category/category_section.dart';
import 'package:conquest/features/MarketPlace/Products/Products_screen/products_section.dart';
import 'package:conquest/features/utils/constants/colors.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controllerP = Get.put(ProductController());
    final controller = Get.put(MarketplaceController());

    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/drawer');
          },
          icon: const Icon(
            Icons.menu,
            size: TSizes.iconLg,
          ),
        ),
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logos/conquest-icon.png',
              height: TSizes.iconLg + 15,
            ),
            const SizedBox(
              width: 5,
            ),
            Image.asset(
              'assets/logos/conquest-string.png',
              height: TSizes.iconLg + 80,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => Wishlistscreen())),
            icon: const Icon(Iconsax.heart),
          ),
          // Cart Button
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            icon: const Icon(Iconsax.shopping_cart),
          ),
        ],
      ),
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
