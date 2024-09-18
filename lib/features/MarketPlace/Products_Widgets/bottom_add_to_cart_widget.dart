import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class BottomAddToCartWidget extends StatelessWidget {
  const BottomAddToCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(
      //     horizontal: TSizes.defaultSpace, vertical: TSizes.defaultSpace / 3),
      //color: TColors.primaryBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                //padding: const EdgeInsets.all(TSizes.sm),
                backgroundColor: TColors.white,
                side: const BorderSide(color: TColors.white, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              ),
              child: Text(
                'Buy Now',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                //padding: const EdgeInsets.all(TSizes.sm),
                backgroundColor: TColors.primary,
                side: const BorderSide(color: TColors.primary),
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
