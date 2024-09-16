// import 'dart:developer';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../../common/widgets/TCurvedEdgesWidget.dart';
// import '../../../../../common/widgets/Troundedimage.dart';
// import '../../../../core/Controllers/Product_Controller/product_image_controller.dart';
// import '../../../../core/model/Product_Models/product.dart';
// import '../../../utils/constants/colors.dart';
// import '../../../utils/constants/sizes.dart';
// import '../../../utils/helpers/helper_functions.dart';
//
// class ProductImageSlider extends StatelessWidget {
//   final ProductModel productModel;
//   const ProductImageSlider({
//     super.key,
//     required this.productModel,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = ProductImageController.instance;
//     final images = controller.getAllProductImage(productModel);
//
//     return TCurvedEdgesWidget(
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           /// Main Large Image (Swipable with PageView)
//           Obx(() {
//             final image = controller.selectedProductImage.value;
//             log('Image Value inside image widget ${controller.selectedProductImage.value}');
//             return GestureDetector(
//               onTap: () => controller.showZoomableImage(context, image),
//               child: SizedBox(
//                 height: 400,
//                 width: double.infinity,
//                 child: CachedNetworkImage(
//                   imageUrl: image,
//                   fit: BoxFit.fitWidth,
//                 ),
//               ),
//             );
//           }),
//
//           /// Image Slider (Below the main image)
//           Positioned(
//             right: images.length == 1
//                 ? THelperFunctions.screenWidth(context) * 0.5 - 30
//                 : images.length >= 4
//                     ? 15
//                     : 0,
//             bottom: 30,
//             left: images.length >= 4 ? 15 : null,
//             child: SizedBox(
//               height: 80,
//               width: images.length == 1
//                   ? 80
//                   : images.length == 2
//                       ? MediaQuery.of(context).size.width * 0.65
//                       : images.length == 3
//                           ? MediaQuery.of(context).size.width * 0.8
//                           : MediaQuery.of(context).size.width * 0.9,
//               child: ListView.separated(
//                 scrollDirection: Axis.horizontal,
//                 shrinkWrap: true,
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 itemCount: images.length,
//                 separatorBuilder: (_, __) => const SizedBox(
//                   width: TSizes.spaceBtwItems - 5,
//                 ),
//                 itemBuilder: (_, index) {
//                   return TRoundedImage(
//                     onPressed: () =>
//                         controller.selectedProductImage.value = images[index],
//                     fit: BoxFit.fitHeight,
//                     backgroundColor: TColors.white,
//                     width: 80,
//                     border: Border.all(
//                         color: controller.selectedProductImage.value ==
//                                 images[index]
//                             ? TColors.primary
//                             : Colors.grey),
//                     padding: const EdgeInsets.all(TSizes.sm),
//                     imageUrl: images[index],
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../../common/widgets/TCurvedEdgesWidget.dart';
import '../../../../core/Controllers/Product_Controller/product_image_controller.dart';
import '../../../../core/model/Product_Models/product.dart';

class ProductImageSlider extends StatelessWidget {
  final ProductModel productModel;
  const ProductImageSlider({
    super.key,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    final controller = ProductImageController.instance;
    final images = controller.getAllProductImage(productModel);

    // PageController to manage page transitions
    final PageController pageController = PageController();

    return TCurvedEdgesWidget(
      child: Column(
        children: [
          // Main Image PageView (Swipable)
          SizedBox(
            height: 400,
            width: double.infinity,
            child: PageView.builder(
              controller: pageController,
              itemCount: images.length,
              onPageChanged: (index) {
                // Update the selected image when the page changes
                controller.selectedProductImage.value = images[index];
              },
              itemBuilder: (context, index) {
                final image = images[index];
                return GestureDetector(
                  onTap: () => controller.showZoomableImage(context, image),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),

          // Smooth Page Indicator below the image
          SizedBox(
            height: 50,
            width: double.infinity,
            child: Center(
              child: SmoothPageIndicator(
                controller: pageController,
                count: images.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.black, // Active dot color
                  dotColor: Colors.grey, // Inactive dot color
                  dotHeight: 8.0,
                  dotWidth: 8.0,
                  expansionFactor: 3, // Expands active dot
                  spacing: 8.0,
                ),
                onDotClicked: (index) {
                  // Update the page in the PageView when a dot is clicked
                  pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
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
