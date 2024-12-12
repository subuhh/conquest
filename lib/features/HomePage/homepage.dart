import 'package:conquest/common/widgets/Iconbuttonwithlabe.dart';
import 'package:conquest/core/Controllers/homepage_controller.dart';
import 'package:conquest/features/AppBar/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../MarketPlace/Carousel/carousel_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomePageController());
    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: CustomAppBar(
        left: 10,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Iconsax.notification,
              size: TSizes.iconLg,
            ),
          ),
        ],
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            children: [
              /// Homepage Content
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SizedBox(
                        height: TSizes.imageCarouselHeight,
                        child: CarouselSection(
                          isLoading: controller.isLoading.value,
                          banners: controller.banners,
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Grid View for Icons
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          IconButtonWithLabel(
                            labelText: 'Quest &\nChallenge',
                            imagePath: 'assets/icons/appicons/cardiogram.svg',
                          ),
                          IconButtonWithLabel(
                            labelText: 'Clan',
                            imagePath:
                                'assets/icons/appicons/nutrition-outline.svg',
                          ),
                          IconButtonWithLabel(
                            labelText: 'League',
                            imagePath: 'assets/icons/appicons/calendar.svg',
                          ),
                          IconButtonWithLabel(
                            labelText: 'Reports',
                            imagePath: 'assets/icons/appicons/person.svg',
                          ),
                        ],
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
