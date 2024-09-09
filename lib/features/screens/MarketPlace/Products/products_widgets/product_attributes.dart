import 'package:conquest/common/widgets/SectionHeading.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../../../../../common/widgets/chips/choice_chip.dart';

class ProductAttributes extends StatelessWidget {
  const ProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color
          const Sectionheading(
            title: 'Select Color',
            showActionButton: false,
          ),
          const SizedBox(
            height: TSizes.spaceBtwItems / 2,
          ),
          Wrap(
            children: [
              TChoiceChip(
                text: 'Green',
                selected: true,
                onSelected: (value) {},
              ),
              TChoiceChip(
                text: 'Blue',
                selected: false,
                onSelected: (value) {},
              ),
              TChoiceChip(
                text: 'Yellow',
                selected: false,
                onSelected: (value) {},
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 1.5),
          // Sizes
          const Sectionheading(
            title: 'Select Size',
            showActionButton: false,
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          Wrap(
            spacing: 8,
            children: [
              TChoiceChip(
                text: 'Eu 34',
                selected: true,
                onSelected: (value) {},
              ),
              TChoiceChip(
                text: 'Eu 36',
                selected: false,
                onSelected: (value) {},
              ),
              TChoiceChip(
                text: 'Eu 38',
                selected: false,
                onSelected: (value) {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
