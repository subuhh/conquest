
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/TCurvedEdgesWidget.dart';
import '../../../../../common/widgets/Troundedimage.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';




class ProductImageSlider extends StatelessWidget {
  const ProductImageSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return TCurvedEdgesWidget(
        child: Container(
          color: dark ? TColors.darkerGrey : TColors.light,
          child: Stack(
            children: [
              ///Main Large image
              SizedBox(
                  height: 400,
                  child: Padding(
                    padding:
                    const EdgeInsets.all(TSizes.productImageRadius * 2),
                    child: Image(
                      fit: BoxFit.fitHeight,
                      image: NetworkImage(
                          "https://cdn.shopify.com/s/files/1/0070/7032/files/product-label-design.jpg?v=1680902906"),
                    ),
                  )),

              /// Image Slider
              Positioned(
                right: 0,
                bottom: 30,
                left: TSizes.defaultSpace,
                child: SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: 6,
                    separatorBuilder: (_, __) => const SizedBox(
                      width: TSizes.spaceBtwItems,
                    ),
                    itemBuilder: (_                                                                                                                                                                                                                                                                 , index) {
                      return TRoundedImage(
                        fit: BoxFit.fitHeight,
                        backgroundColor: dark ? TColors.dark : TColors.white,
                        width: 80,
                        border: Border.all(color: TColors.primary),
                        padding: const EdgeInsets.all(TSizes.sm),
                        imageUrl:
                        'https://cdn.shopify.com/s/files/1/0070/7032/files/product-label-design.jpg?v=1680902906',
                      );
                    },
                  ),
                ),
              ),

              /// AppBar
              AppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Iconsax.arrow_left)),
                actions: [IconButton(onPressed: (){}, icon: Icon(Iconsax.heart5,color: Colors.red,))],
              ),
            ],
          ),
        ));
  }
}
