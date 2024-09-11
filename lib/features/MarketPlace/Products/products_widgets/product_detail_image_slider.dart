import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/TCurvedEdgesWidget.dart';
import '../../../../../common/widgets/Troundedimage.dart';
import '../../../../../core/model/product.dart';
import '../../../../core/Controllers/product_image_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class ProductImageSlider extends StatelessWidget {
  final ProductModel product;
  const ProductImageSlider({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    final controller = Get.put(ProductImageController());
    final images = controller.getAllProductImage(product);

    return TCurvedEdgesWidget(
      child: Container(
        color: dark ? TColors.darkerGrey : TColors.light,
        child: Stack(
          children: [
            /// Main Large Image
            SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(TSizes.productImageRadius * 2),
                child: Center(
                  child: Obx(() {
                    final image = controller.selectedImage.value;
                    return GestureDetector(
                      onTap: () => controller.showEnlargeImage(image),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: image,
                        // progressIndicatorBuilder: (_, __, downloadProgress) =>
                        //     CircularProgressIndicator(
                        //   value: downloadProgress.progress,
                        //   color: TColors.primary,
                        // ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            /// Image Slider (Centered below the main image)
            Positioned(
              right: images.length == 1
                  ? THelperFunctions.screenWidth(context) * 0.5 - 20
                  : 0,
              bottom: 40, // Set the bottom position relative to the large image
              child: SizedBox(
                height: 80,
                width: images.length == 1
                    ? 80
                    : images.length == 2
                        ? MediaQuery.of(context).size.width * 0.65
                        : images.length == 3
                            ? MediaQuery.of(context).size.width * 0.8
                            : MediaQuery.of(context).size.width * 0.9,
                child: ListView.separated(
                  itemCount: images.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: TSizes.spaceBtwItems),
                  itemBuilder: (_, index) => Obx(
                    () {
                      final imageSelected =
                          controller.selectedImage.value == images[index];
                      return TRoundedImage(
                        // fit: BoxFit.fitHeight,
                        onPressed: () =>
                            controller.selectedImage.value = images[index],
                        backgroundColor: dark ? TColors.dark : TColors.white,
                        width: 80,
                        border: Border.all(
                          width: 2,
                          color: imageSelected
                              ? TColors.primary
                              : Colors.transparent,
                        ),
                        padding: const EdgeInsets.all(TSizes.sm),
                        imageUrl: images[index],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
