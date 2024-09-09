import 'package:conquest/core/model/product.dart';
import 'package:conquest/features/utils/helpers/pricing_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../common/widgets/product_price_text.dart';
import '../../../../../common/widgets/RoundedContainer.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class ProductMetaData extends StatelessWidget {
  final ProductModel productModel;
  const ProductMetaData({
    super.key,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    final discountedPercentage = TPricingCalculator.calculateDiscountPercentage(
      productModel.originalPrice,
      productModel.discountedPrice,
    );

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name
              Flexible(
                child: Text(
                  productModel.name,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 19),
                  maxLines: 2, // Allow a maximum of 2 lines
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),

              // Share Button (Aligned to the right)
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
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
              ),
            ],
          ),

          // Flavour Text
          Text(
            '1 Kg [2.2 lb], Chocolate Hazelnut',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontSize: 18,
                ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems * 2),

          // Price, In or Out Stock
          Row(
            children: [
              // New Price Tag
              ProductPriceText(
                price: '${productModel.discountedPrice}',
                isLarge: true,
              ),
              const SizedBox(
                width: TSizes.spaceBtwItems,
              ),

              // Old Price
              RichText(
                text: TextSpan(
                  text: 'MRP ',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 20, fontWeight: FontWeight.w400)
                      .apply(
                        decoration: TextDecoration.lineThrough,
                      ),
                  children: [
                    TextSpan(
                      text: '₹${productModel.originalPrice}',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 20, fontWeight: FontWeight.w400)
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
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.sm,
                  vertical: TSizes.xs,
                ),
                child: Text(
                  '$discountedPercentage% OFF',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(color: TColors.white),
                ),
              ),
            ],
          ),

          // Save Text
          Text(
            'Save ₹${productModel.originalPrice - productModel.discountedPrice}',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.green),
          ),
          const SizedBox(height: TSizes.defaultSpace / 4.5),

          // Inclusive of all taxes
          Text(
            'Inclusive of all taxes',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: TSizes.defaultSpace / 2),

          // Price With Premium
          Container(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TColors.primary),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '₹3899',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.black,
                      ),
                ),
                Text(
                  ' With',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: TColors.black,
                      ),
                ),
                SvgPicture.asset(
                  'assets/icons/appicons/premiumicon.svg',
                  height: 26,
                  colorFilter:
                      const ColorFilter.mode(TColors.primary, BlendMode.srcIn),
                ),
                Text(
                  ' Premium',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: TColors.primary, fontSize: 19),
                ),
              ],
            ),
          ),
          const SizedBox(height: TSizes.defaultSpace / 2),
          // Stack In or Out Status
        ],
      ),
    );
  }
}
