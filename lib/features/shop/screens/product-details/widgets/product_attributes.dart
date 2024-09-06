import 'package:conquest/common/widgets/ProductPriceText.dart';
import 'package:conquest/common/widgets/ProductTitleText.dart';
import 'package:conquest/common/widgets/RoundedContainer.dart';
import 'package:conquest/common/widgets/SectionHeading.dart';
import 'package:conquest/features/utils/constants/colors.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProductAttributes extends StatelessWidget {
  const ProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Selected Attribute Pricing & Description
        RoundedContainer(
          padding: EdgeInsets.all(TSizes.md),
          backgroundColor: TColors.grey,
          child: Column(
            children: [
              Row(
                children: [
                  Sectionheading(
                    title: 'Variation',
                    showActionButton: false,
                  ),
                  SizedBox(
                    width: TSizes.spaceBtwItems,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ProductTitletext(
                            title: 'Price : ',
                            smallSize: true,
                          ),
                          const SizedBox(
                            width: TSizes.spaceBtwItems,
                          ),

                          ///Actual Price
                          Text(
                            '₹250',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .apply(decoration: TextDecoration.lineThrough),
                          ),
                          const SizedBox(
                            width: TSizes.spaceBtwItems,
                          ),

                          ///SalePrice
                          ProductPricetext(price: '200'),
                        ],
                      ),

                      ///Stack
                      Row(
                        children: [
                          const ProductTitletext(
                            title: 'Stock : ',
                            smallSize: true,
                          ),
                          Text(
                            'In Stock',
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        ],
                      ),

                    ],
                  )
                ],
              ),
              ProductTitletext(
                title:
                'This is the Description of the Product and it can go up to max 4 lines',
                smallSize: true,
                maxLines: 4,
              )
            ],
          ),

        ),

        /// Attribute
        Column(
          children: [],
        )

      ],
    );
  }
}
