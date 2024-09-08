import 'package:conquest/common/widgets/SectionHeading.dart';
import 'package:conquest/features/screens/MarketPlace/Products/products_widgets/Product_Meta_data.dart';
import 'package:conquest/features/screens/MarketPlace/Products/products_widgets/bottom_add_to_cart_widget.dart';
import 'package:conquest/features/screens/MarketPlace/Products/products_widgets/product_attributes.dart';
import 'package:conquest/features/screens/MarketPlace/Products/products_widgets/product_detail_image-slider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import '../../../../utils/constants/sizes.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: const BottomAddToCartWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///1 - Product Image Slider
            const ProductImageSlider(),

            /// Product Details
            const ProductMetaData(),

            Padding(
              padding: const EdgeInsets.only(right: TSizes.defaultSpace,left: TSizes.defaultSpace,bottom: TSizes.defaultSpace),
              child: Column(
                children: [


                  ///Attributes
                  const ProductAttributes(),
                  const SizedBox(height: TSizes.spaceBtwSections,),

                  /// Checkout Button
                  SizedBox(width: double.infinity,child: ElevatedButton(onPressed: (){}, child: const Text('Checkout')),),
                  const SizedBox(height: TSizes.spaceBtwSections,),

                  ///Description
                  const Sectionheading(title: 'Description',showActionButton: false,),
                  const SizedBox(height: TSizes.spaceBtwItems,),
                  const ReadMoreText(
                      'This is a Product description for Blue Sleeve less vest. There are more things that can be added but i am just practising nothing else ',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Less',
                    moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),

                  ),

                  /// Reviews
                  const Divider(),
                  const SizedBox(height: TSizes.spaceBtwItems,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Sectionheading(title: 'Reviews (199)',showActionButton: false,),
                      IconButton(onPressed: (){}, icon: const Icon(Iconsax.arrow_right_3,size: 18,)),
                    ],
                  ),



                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}

