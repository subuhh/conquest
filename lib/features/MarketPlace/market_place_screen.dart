import 'package:conquest/core/Controllers/marketplace_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:conquest/common/widgets/searchbar.dart';
import 'package:conquest/features/MarketPlace/Carousel/carousel_section.dart';
import 'package:conquest/features/MarketPlace/Category/category_section.dart';
import 'package:conquest/features/MarketPlace/Products/Products_screen/products_section.dart';
import 'package:conquest/features/utils/constants/colors.dart';
import 'package:conquest/features/utils/constants/sizes.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MarketplaceController controller = Get.put(MarketplaceController());
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
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            icon: const Icon(
              Icons.shopping_cart,
              size: TSizes.iconLg,
            ),
          ),
        ],
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchMarketplaceData();
          },
          color: TColors.primary,
          backgroundColor: Colors.white,
          child: Column(
            children: [
              const Searchbar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
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
                      ProductsSection(
                        title: 'Trending Now',
                        isLoading: controller.isLoading.value,
                        products: controller.products,
                      ),

                      // Bestseller Section
                      ProductsSection(
                        title: 'Bestseller',
                        isLoading: controller.isLoading.value,
                        products: controller.products,
                      ),

                      // Top Picks Section
                      ProductsSection(
                        title: 'Top Picks',
                        isLoading: controller.isLoading.value,
                        products: controller.products,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
