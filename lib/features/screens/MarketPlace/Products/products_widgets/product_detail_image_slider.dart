import 'package:flutter/material.dart';
import '../../../../../common/widgets/TCurvedEdgesWidget.dart';
import '../../../../../common/widgets/Troundedimage.dart';
import '../../../../../core/model/product.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

class ProductImageSlider extends StatelessWidget {
  final ProductModel productModel;
  const ProductImageSlider({
    super.key,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final imageCount = productModel.images.length;
    return TCurvedEdgesWidget(
      child: Container(
        color: dark ? TColors.darkerGrey : TColors.light,
        child: Stack(
          alignment: Alignment.center, // Align children centrally
          children: [
            /// Main Large Image
            SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(TSizes.productImageRadius * 2),
                child: Image(
                  fit: BoxFit.fitHeight,
                  image: NetworkImage(
                    productModel.images[0],
                  ),
                ),
              ),
            ),

            /// Image Slider (Centered below the main image)
            Positioned(
              bottom: 40, // Set the bottom position relative to the large image
              child: SizedBox(
                height: 80,
                width: imageCount == 1
                    ? 80
                    : imageCount == 2
                        ? MediaQuery.of(context).size.width * 0.4
                        : MediaQuery.of(context).size.width * 0.8,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: productModel.images.length,
                  separatorBuilder: (_, __) => const SizedBox(
                    width: TSizes.spaceBtwItems,
                  ),
                  itemBuilder: (_, index) {
                    return TRoundedImage(
                      fit: BoxFit.fitHeight,
                      backgroundColor: dark ? TColors.dark : TColors.white,
                      width: 80,
                      border: Border.all(color: TColors.primary),
                      padding: const EdgeInsets.all(TSizes.sm),
                      imageUrl:
                          // "https://cdn.shopify.com/s/files/1/0070/7032/files/product-label-design.jpg?v=1680902906",
                          productModel.images[index],
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
