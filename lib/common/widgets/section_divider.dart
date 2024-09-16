import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

class SectionDivider extends StatelessWidget {
  final bool isUpperSizedBox;
  const SectionDivider({super.key, this.isUpperSizedBox = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isUpperSizedBox
            ? const SizedBox(height: TSizes.spaceBtwItems)
            : const SizedBox(height: 0),
        Container(
          height: TSizes.spaceBtwSections / 4,
          color: TColors.secondaryBackground,
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
      ],
    );
  }
}
