import 'package:flutter/material.dart';
import '../../../../../common/widgets/product_price_text.dart';
import '../../../../../common/widgets/RoundedContainer.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class ProductMetaData extends StatelessWidget {
  const ProductMetaData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
            children: [
              Text(
                'Green Nike Sports Shirt',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              // Share Button
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        12.0), // Adjust the radius as needed
                    border: Border.all(
                      color:
                          Colors.grey, // Or any color you want for the border
                      width: 1.0, // Adjust the border width as needed
                    ),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(
                    Icons.share,
                    size: TSizes.iconMd,
                  ),
                ),
              )
            ],
          ),

          // Flavour and Size
          Text(
            '1 Kg [2.2 lb], Chocolate Hazelnut',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontSize: 20,
                ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems * 2),

          // Price, Stock & Brand
          Row(
            children: [
              // New Price Tag
              const ProductPriceText(
                price: '175',
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
                      text: '₹175',
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
                radius: TSizes.md,
                backgroundColor: TColors.secondary.withOpacity(0.8),
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.sm,
                  vertical: TSizes.xs,
                ),
                child: Text(
                  '25%',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(color: TColors.black),
                ),
              ),
            ],
          ),

          ///Stack Status
          Text(
            'In Stock',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.green),
          ),
        ],
      ),
    );
  }
}
