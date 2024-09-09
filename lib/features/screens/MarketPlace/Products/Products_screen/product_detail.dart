import 'package:conquest/common/widgets/SectionHeading.dart';
import 'package:conquest/features/screens/MarketPlace/Products/products_widgets/product_meta_data.dart';
import 'package:conquest/features/screens/MarketPlace/Products/products_widgets/bottom_add_to_cart_widget.dart';
import 'package:conquest/features/screens/MarketPlace/Products/products_widgets/product_attributes.dart';
import 'package:conquest/features/screens/MarketPlace/Products/products_widgets/product_detail_image-slider.dart';
import 'package:conquest/features/screens/MarketPlace/Products/products_widgets/section_divider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../Product_reviews/product_reviews_screen.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          // Search Button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Iconsax.search_normal),
          ),
          // Favourite Button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Iconsax.heart),
          ),
          // Cart Button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Iconsax.shopping_cart),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1 - Product Image Slider
            const ProductImageSlider(),

            // 2 - Product Details (Title, Flavour & Size, Price, In Stock)
            const ProductMetaData(),
            const SizedBox(height: TSizes.spaceBtwItems),

            // 3 - Colors and Sizes
            const ProductAttributes(),
            const SectionDivider(),

            // Product Quantity
            Padding(
              padding: const EdgeInsets.only(
                left: TSizes.defaultSpace,
                right: TSizes.defaultSpace,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Sectionheading(
                    title: 'Quantity',
                    showActionButton: false,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Minus button
                      Container(
                        decoration: BoxDecoration(
                          color: TColors.grey.withOpacity(0.7),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                          ),
                          border: Border.all(
                            color: TColors.black,
                            width: 1.0,
                          ),
                        ),
                        width: 40,
                        height: 40,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Iconsax.minus,
                            color: TColors.black,
                          ),
                          onPressed: () {
                            // Handle minus button
                          },
                        ),
                      ),

                      // Quantity box
                      Container(
                        width: 50,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: TColors.white,
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: TColors.black,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Text(
                          '1', // Quantity number
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),

                      // Plus button
                      Container(
                        decoration: BoxDecoration(
                          color: TColors.grey.withOpacity(0.7),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                          border: Border.all(
                            color: TColors.black,
                            width: 1.0,
                          ),
                        ),
                        width: 40,
                        height: 40,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Iconsax.add,
                            color: TColors.black,
                          ),
                          onPressed: () {
                            // Handle plus button
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SectionDivider(),


            // Description
            const Sectionheading(
              title: 'Product Description',
              showActionButton: false,
              isPadding: true,
              isHeader: true,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Description Text
            const Padding(
              padding: EdgeInsets.only(
                left: TSizes.defaultSpace,
                right: TSizes.defaultSpace,
              ),
              child: ReadMoreText(
                'Biozyme Performance Whey- Recognized by the World!\nMuscleBlaze Biozyme Performance Whey is crafted exclusively for fitness and muscle-building champions who want their protein supplement to be as effective as their efforts. It is scientifically designed with Enhanced Absorption Formula (EAF®) to maximize the bioavailability of protein for the Indian bodies. It’s a part of MB’s pioneering innovation- the BIOZYME series. The other fitness supplements in this iconic series are Biozyme Whey Iso-Zero & Biozyme Whey Protein.',
                trimLines: 7,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' Show more',
                trimExpandedText: ' Show Less',
                moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ),

            const SectionDivider(),

            // Reviews
            const ProductReviewsScreen(),
            const SectionDivider(isUpperSizedBox: false,),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAddToCartWidget(),
    );
  }
}
