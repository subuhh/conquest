import 'package:conquest/features/shop/screens/product-details/widgets/rating_share_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widgets/ProductPriceText.dart';
import '../../../../../common/widgets/ProductTitleText.dart';
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
      padding: EdgeInsets.only(
          right: TSizes.defaultSpace,
          left: TSizes.defaultSpace,
          bottom: TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Rating & Share Button
          RatingAndShare(),

          /// Price, Title, Stock & Brand
          Row(
            children: [
              ///Sale Tag
              RoundedContainer(
                radius: TSizes.sm,
                backgroundColor: TColors.secondary.withOpacity(0.8),
                padding: const EdgeInsets.symmetric(horizontal: TSizes.sm,vertical: TSizes.xs,
                ),
                child: Text('25%',style: Theme.of(context).textTheme.labelLarge!.apply(color: TColors.black),),
              ),
              const SizedBox(width: TSizes.spaceBtwItems,),
              ///Price
              Text("₹250", style: Theme.of(context).textTheme.titleSmall!.apply(decoration: TextDecoration.lineThrough),),
              const SizedBox(width: TSizes.spaceBtwItems),
              const ProductPricetext(price: '175',isLarge: true,),
            ],
          ),

          ///Title
          const ProductTitletext(title: 'Green Nike Sports Shirt'),
          const SizedBox(height: TSizes.spaceBtwItems/1.5,),
          ///Stack Status
          Row(
            children: [
              const ProductTitletext(title:'Status'),
              const SizedBox(width: TSizes.spaceBtwItems,),
              Text('In Stock', style: Theme.of(context).textTheme.titleMedium,),
              const SizedBox(height: TSizes.spaceBtwItems/1.5,)
            ],
          ),

          ///Brand
        ],
      ),
    );
  }
}
