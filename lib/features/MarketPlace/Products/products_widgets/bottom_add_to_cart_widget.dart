import 'package:conquest/features/utils/constants/colors.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class BottomAddToCartWidget extends StatelessWidget {
  const BottomAddToCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.symmetric(
          horizontal: TSizes.defaultSpace, vertical: TSizes.defaultSpace / 2),
      color: TColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: TColors.white,
                side: const BorderSide(color: TColors.black, width: 1.5),
              ),
              child: Text(
                'Buy Now',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          SizedBox(width: TSizes.spaceBtwItems,),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: TColors.primary,
                side: const BorderSide(color: TColors.white),
              ),
              child: Text(
                'Add to Card',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: TColors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
