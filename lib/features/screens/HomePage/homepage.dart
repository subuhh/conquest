import 'package:conquest/common/widgets/Iconbuttonwithlabe.dart';
import 'package:conquest/common/widgets/searchbar.dart';
import 'package:conquest/features/screens/MarketPlace/Carousel/carousel_section.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:conquest/features/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class homepage extends StatelessWidget {
  const homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// AppBar
      appBar:
      AppBar(
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logos/conquest-icon.png',
              height: TSizes.iconLg + 15,
            ),
            const SizedBox(width: 5,),
            Image.asset(
              'assets/logos/conquest-string.png',
              height: TSizes.iconLg+80,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Iconsax.notification,
                size: TSizes.iconLg,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      child: CarouselSection(isLoading: false, imageUrls: ['assets/Banners/img_3.jpg','assets/Banners/img_1.png',"assets/Banners/img.png",'assets/Banners/img_4.jpg'],),
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
                    const SizedBox(height: TSizes.spaceBtwItems),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    const SizedBox(height: TSizes.spaceBtwItems),

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
      ),
    );
  }
}
