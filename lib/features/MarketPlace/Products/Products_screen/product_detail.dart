import 'package:conquest/common/widgets/SectionHeading.dart';
import 'package:conquest/core/Controllers/Product_Controller/cart_controller.dart';
import 'package:conquest/core/model/Product_Models/product.dart';
import 'package:conquest/common/widgets/section_divider.dart';
import 'package:conquest/features/MarketPlace/Products_Widgets/cart_counter_icon.dart';
import 'package:conquest/features/MarketPlace/Products_Widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import '../../../../core/Controllers/Product_Controller/variation_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../products_widgets/bottom_add_to_cart_widget.dart';
import '../../products_widgets/product_attributes.dart';
import '../../products_widgets/product_detail_image_slider.dart';
import '../../products_widgets/product_meta_data.dart';
import '../Product_reviews/product_reviews_screen.dart';

class ProductDetail extends StatefulWidget {
  final ProductModel productModel;
  const ProductDetail({super.key, required this.productModel});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int selectedQuantity = 1;
  final controller = VariationController.instance;
  final cartController = CartController.instance;

  void initState() {
    super.initState();
    controller.resetSelectedAttributes();
    controller.initializeSelectedAttributes(widget.productModel);
    // cartController.productQuantityInCart.value = 1;
    cartController.updateAlreadyAddedProductCount(widget.productModel);
    if (cartController.productQuantityInCart == 0) {
      cartController.productQuantityInCart.value = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.primary,
        elevation: 10,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          // Search Button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Iconsax.search_normal,
              color: Colors.white,
            ),
          ),
          // Favourite Button
          FavoriteButton(
            isDecoration: false,
            productId: widget.productModel.id,
          ),
          // Cart Button
          CartCounterIcon(isDecorated: true),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1 - Product Image Slider
            ProductImageSlider(productModel: widget.productModel),

            // 2 - Product Details (Title, Price, In Stock)
            ProductMetaData(productModel: widget.productModel),
            const SizedBox(height: TSizes.spaceBtwItems / 2),

            // 3 - Colors and Sizes
            if (widget.productModel.productType != 'Single')
              ProductAttributes(productModel: widget.productModel),
            const SectionDivider(),

            // Product Quantity
            Obx(
              () => Padding(
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
                            onPressed: () =>
                                cartController.productQuantityInCart.value < 2
                                    ? null
                                    : cartController
                                        .productQuantityInCart.value -= 1,
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
                            cartController.productQuantityInCart.value
                                .toString(), // Quantity number
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
                            onPressed: () =>
                                cartController.productQuantityInCart += 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
            Padding(
              padding: const EdgeInsets.only(
                left: TSizes.defaultSpace,
                right: TSizes.defaultSpace,
              ),
              child: ReadMoreText(
                widget.productModel.description!,
                trimLines: 7,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' Show more',
                trimExpandedText: ' Show Less',
                moreStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                lessStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ),

            const SectionDivider(),

            // Reviews
            const ProductReviewsScreen(),
            const SectionDivider(isUpperSizedBox: false),
          ],
        ),
      ),
      // Buy Now and Add to Cart Buttons
      bottomNavigationBar: BottomAddToCartWidget(product: widget.productModel),
    );
  }
}
