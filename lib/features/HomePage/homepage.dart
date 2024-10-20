import 'package:conquest/common/widgets/Iconbuttonwithlabe.dart';
import 'package:conquest/common/widgets/searchbar.dart';
import 'package:conquest/core/Controllers/homepage_controller.dart';
import 'package:conquest/features/AppBar/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/Controllers/user_controller.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/helper_functions.dart';
import '../MarketPlace/Carousel/carousel_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    Get.put(UserController());

    final HomePageController controller = Get.put(HomePageController());
    return Scaffold(
      /// AppBar
      backgroundColor: TColors.secondaryBackground,
      appBar: CustomAppBar(actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Iconsax.notification,
              size: TSizes.iconLg,
            )),
      ],),

      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              /// Search Bar
              const Searchbar(),

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
                          //  banners: controller.banners,
                        ),
                        // child: CarouselView(
                        //   itemSnapping: true,
                        //   itemExtent: THelperFunctions.screenWidth(context) - 35,
                        //   children: List.generate(
                        //     10,
                        //     (int index) {
                        //       return Container(
                        //         color: Colors.grey,
                        //         child: Image.network(
                        //           'https://picsum.photos/400?random=$index',
                        //           fit: BoxFit.cover,
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Iconbuttonwithlabel(
                            labelText: 'Workouts',
                            imagePath: 'assets/icons/appicons/cardiogram.svg',
                          ),
                          Iconbuttonwithlabel(
                            labelText: 'Nutrition',
                            imagePath:
                                'assets/icons/appicons/nutrition-outline.svg',
                          ),
                          Iconbuttonwithlabel(
                            labelText: 'Schedule',
                            imagePath: 'assets/icons/appicons/calendar.svg',
                          ),
                          Iconbuttonwithlabel(
                            labelText: 'Profile',
                            imagePath: 'assets/icons/appicons/person.svg',
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems / 2),

                      // Cards
                      Column(
                        children: List.generate(4, (index) {
                          return SizedBox(
                            height: 200,
                            width: THelperFunctions.screenWidth(context),
                            child: Card(
                              color: Colors.grey[350],
                              child: const Center(
                                child: Text('More Widgets can be added here'),
                              ),
                            ),
                          );
                        }),
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
