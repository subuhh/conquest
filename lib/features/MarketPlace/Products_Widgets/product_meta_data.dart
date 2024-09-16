import 'package:conquest/core/model/Product_Models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/RoundedContainer.dart';
import '../../../../core/Controllers/Product_Controller/variation_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/pricing_calculator.dart';
import '../../../../utils/theme/customthemes/textThemes.dart';

class ProductMetaData extends StatelessWidget {
  final ProductModel productModel;
  const ProductMetaData({
    super.key,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    final variationController = VariationController.instance;

    int price = int.parse(productModel.price.trim());
    int salePrice = int.parse(productModel.salePrice.trim());

    final discountedPercentage =
        TPricingCalculator.calculateDiscountPercentage(price, salePrice);

    return Padding(
      padding: const EdgeInsets.only(
        right: TSizes.defaultSpace,
        left: TSizes.defaultSpace,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name
              Flexible(
                child: Obx(() {
                  return Text(
                    '${productModel.title}${variationController.selectedAttributeSummary.value}',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontSize: 17),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  );
                }),
              ),
              const SizedBox(width: 10),
              // Share Button (Aligned to the right)
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(
                    Icons.share,
                    size: TSizes.iconMd,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),

          // Price,
          Row(
            children: [
              // New Price Tag
              Obx(() {
                return Text(
                  '₹${variationController.variationPrice.value}',
                  style: TTextTheme.lightTextTheme.headlineSmall!
                      .copyWith(fontSize: 22),
                );
              }),

              const SizedBox(width: TSizes.spaceBtwItems / 1.5),
              // Old Price
              RichText(
                text: TextSpan(
                  text: 'MRP',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 14, fontWeight: FontWeight.w400)
                      .apply(
                        decoration: TextDecoration.lineThrough,
                      ),
                  children: [
                    TextSpan(
                      text: ' ₹${productModel.price}',
                      style: TTextTheme.lightTextTheme.titleLarge!
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w400)
                          .apply(
                            decoration: TextDecoration.lineThrough,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              // Discounted Container
              RoundedContainer(
                radius: TSizes.sm,
                backgroundColor: Colors.green,
                height: 25,
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.sm,
                  vertical: TSizes.xs,
                ),
                child: Text(
                  '${discountedPercentage}% OFF',
                  style: TTextTheme.lightTextTheme.bodyLarge!
                      .copyWith(color: TColors.white, fontSize: 12),
                ),
              ),
            ],
          ),

          // Save Text
          Text(
            'Save ₹${productModel.price}',
            style: TTextTheme.lightTextTheme.titleLarge!
                .copyWith(color: Colors.green, fontSize: 14),
          ),

          // Inclusive of all taxes
          Text(
            'Inclusive of all taxes',
            style: TTextTheme.lightTextTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: TSizes.defaultSpace / 2),

          // Price With Premium
          Container(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TColors.primary),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '₹3899',
                  style: TTextTheme.lightTextTheme.headlineSmall!
                      .copyWith(color: Colors.black, fontSize: 14),
                ),
                Text(
                  ' with ',
                  style: TTextTheme.lightTextTheme.headlineSmall!
                      .copyWith(color: TColors.black, fontSize: 14),
                ),
                Center(
                  child: SvgPicture.asset(
                    'assets/icons/appicons/premiumicon.svg',
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                        TColors.primary, BlendMode.srcIn),
                  ),
                ),
                Text(
                  ' Premium',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: TColors.primary, fontSize: 16),
                ),
              ],
            ),
          ),
          // Stack In or Out Status
        ],
      ),
    );
  }
}
