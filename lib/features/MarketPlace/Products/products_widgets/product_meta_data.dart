import 'package:conquest/core/model/Product_Models/product.dart';
import 'package:conquest/features/utils/theme/customthemes/textThemes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../common/widgets/RoundedContainer.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/pricing_calculator.dart';

class ProductMetaData extends StatelessWidget {
  final ProductModel productModel;
  const ProductMetaData({
    super.key,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
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
                child: Text(
                  productModel.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontSize: 18),
                  maxLines: 3, // Allow a maximum of 2 lines
                  overflow: TextOverflow.ellipsis,
                ),
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

          // Flavour Text
          Text(
            '1 Kg [2.2 lb]',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: TColors.darkerGrey),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Price, In or Out Stock
          Row(
            children: [
              // New Price Tag
              Text(
                '₹${productModel.salePrice}',
                style: TTextTheme.lightTextTheme.headlineSmall!
                    .copyWith(fontSize: 26),
              ),
              const SizedBox(width: TSizes.spaceBtwItems / 1.5),
              // Old Price
              RichText(
                text: TextSpan(
                  text: 'MRP ',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 19, fontWeight: FontWeight.w400)
                      .apply(
                        decoration: TextDecoration.lineThrough,
                      ),
                  children: [
                    TextSpan(
                      text: '₹${productModel.price}',
                      style: TTextTheme.lightTextTheme.titleLarge!
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
                height: 27,
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.sm,
                  vertical: TSizes.xs,
                ),
                child: Text(
                  '${discountedPercentage}% OFF',
                  style: TTextTheme.lightTextTheme.bodyLarge!
                      .apply(color: TColors.white),
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
              fontSize: 14,
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
                      .copyWith(color: Colors.black, fontSize: 16),
                ),
                Text(
                  ' With ',
                  style: TTextTheme.lightTextTheme.headlineSmall!
                      .copyWith(color: TColors.black, fontSize: 16),
                ),
                Center(
                  child: SvgPicture.asset(
                    'assets/icons/appicons/premiumicon.svg',
                    height: 20,
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
