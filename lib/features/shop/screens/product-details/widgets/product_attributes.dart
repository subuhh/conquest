import 'package:conquest/common/widgets/ProductPriceText.dart';
import 'package:conquest/common/widgets/ProductTitleText.dart';
import 'package:conquest/common/widgets/RoundedContainer.dart';
import 'package:conquest/common/widgets/SectionHeading.dart';
import 'package:conquest/features/utils/constants/colors.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widgets/chips/choice_chip.dart';

class ProductAttributes extends StatelessWidget {
  const ProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        ///Selected Attribute Pricing & Description
        RoundedContainer(
          padding: const EdgeInsets.all(TSizes.md),
          backgroundColor: TColors.grey,
          child: Column(
            children: [
              Row(
                children: [
                  const Sectionheading(
                    title: 'Variation',
                    showActionButton: false,
                  ),
                  const SizedBox(
                    width: TSizes.spaceBtwItems,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const ProductTitletext(
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
                          const ProductPricetext(price: '200'),
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
              const ProductTitletext(
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
 crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Sectionheading(title: 'Colors',showActionButton: false,),
            const SizedBox(
              height: TSizes.spaceBtwItems / 2,
            ),
            Wrap(
              children: [
                TChoiceChip(
                  text: 'Green',
                  selected: true,
                  onSelected: (value){},
                ),
                TChoiceChip(
                  text: 'Blue',
                  selected: false,
                  onSelected: (value){},
                ),
                TChoiceChip(
                  text: 'Yellow',
                  selected: false,
                  onSelected: (value){},
                ),

              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Sectionheading(title: 'Size',showActionButton: false,),
            const SizedBox(
              height: TSizes.spaceBtwItems / 2,
            ),
            Wrap(
              spacing: 8,
              children: [
                TChoiceChip(
                  text: 'Eu 34',
                  selected: true,
                  onSelected: (value){},
                ),
                TChoiceChip(
                  text: 'Eu 36',
                  selected: false,
                  onSelected: (value){},
                ),
                TChoiceChip(
                  text: 'Eu 38',
                  selected: false,
                  onSelected: (value){},
                ),


              ],
            )
          ],
        ),
      ],
    );
  }
}
