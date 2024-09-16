import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/TCurvedEdgesWidget.dart';
import '../../../../../common/widgets/Troundedimage.dart';
import '../../../../core/Controllers/Product_Controller/product_image_controller.dart';
import '../../../../core/model/Product_Models/product.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class ProductImageSlider extends StatelessWidget {
  final ProductModel productModel;
  const ProductImageSlider({
    super.key,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductImageController());
    final images = controller.getAllProductImage(productModel);

    return TCurvedEdgesWidget(
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// Main Large Image (Swipable with PageView)
          Obx(() {
            final image = controller.selectedProductImage.value;
            return GestureDetector(
              onTap: () => controller.showZoomableImage(context, image),
              child: SizedBox(
                height: 400,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.fitWidth,
                ),
              ),
            );
          }),

          /// Image Slider (Below the main image)
          Positioned(
            right: images.length == 1
                ? THelperFunctions.screenWidth(context) * 0.5 - 30
                : images.length >= 4
                    ? 15
                    : 0,
            bottom: 30,
            left: images.length >= 4 ? 15 : null,
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
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: images.length,
                separatorBuilder: (_, __) => const SizedBox(
                  width: TSizes.spaceBtwItems-5,
                ),
                itemBuilder: (_, index) {
                  return TRoundedImage(
                    onPressed: () =>
                        controller.selectedProductImage.value = images[index],
                    fit: BoxFit.fitHeight,
                    backgroundColor: TColors.white,
                    width: 80,
                    border: Border.all(color:controller.selectedProductImage.value == images[index]?TColors.primary:Colors.grey),
                    padding: const EdgeInsets.all(TSizes.sm),
                    imageUrl: images[index],
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
