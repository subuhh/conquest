import 'package:conquest/common/widgets/SectionHeading.dart';
import 'package:conquest/core/model/product.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:conquest/features/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import '../../../../../common/widgets/chips/choice_chip.dart';

class ProductAttributes extends StatefulWidget {

  final ProductModel productModel;
  const ProductAttributes({super.key, required this.productModel});

  @override
  State<ProductAttributes> createState() => _ProductAttributesState();
}

class _ProductAttributesState extends State<ProductAttributes> {
  String? selectedColor;
  String? selectedSize;
  String? selectedFlavour;
  String? selectedWeight;

  @override
  Widget build(BuildContext context) {
    List<String> castToListString(List<dynamic>? list) {
      if (list == null) return [];
      return list.map((item) => item.toString()).toList();
    }

    List<String> splitFlavours(String? flavours) {
      if (flavours == null || flavours.isEmpty) return [];
      return flavours.split(',').map((flavour) => flavour.trim()).toList();
    }

    return Padding(
      padding: const EdgeInsets.only(left: TSizes.defaultSpace),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.productModel.productType == 'Clothing') ...[
            // Color
            const Sectionheading(
              title: 'Select Color',
              showActionButton: false,
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems / 2,
            ),
            Wrap(
              spacing: 8,
              children: castToListString(widget.productModel
                      .clothingAttributes?['colors'] as List<dynamic>?)
                  .map(
                    (color) => TChoiceChip(
                      text: THelperFunctions.capitalizeFirstLetter(color),
                      selected: color ==
                          selectedColor, // Manage selection state as needed
                      onSelected: (value) {
                        setState(() {
                          selectedColor = value ? color : null;
                        });
                      },
                    ),
                  )
                  .toList(),
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
              children: castToListString(widget.productModel
                      .clothingAttributes?['sizes'] as List<dynamic>?)
                  .map(
                    (size) => TChoiceChip(
                      text: THelperFunctions.capitalizeFirstLetter(size),
                      selected: size == selectedSize,
                      onSelected: (value) {
                        setState(() {
                          selectedSize = value ? size : null;
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
          if (widget.productModel.productType == 'Supplement') ...[
            // Color
            if (widget.productModel.supplementAttributes?['flavour'] !=
                'NA') ...[
              const Sectionheading(
                title: 'Select Flavour',
                showActionButton: false,
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems / 2,
              ),
              Wrap(
                spacing: 8,
                children: splitFlavours(widget.productModel
                        .supplementAttributes?['flavour'] as String?)
                    .map(
                      (flavour) => TChoiceChip(
                        text: flavour,
                        selected: flavour == selectedFlavour,
                        onSelected: (value) {
                          setState(() {
                            selectedFlavour = value ? flavour : null;
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 1.5),
            ],

            // Sizes
            const Sectionheading(
              title: 'Select Weight',
              showActionButton: false,
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            Wrap(
              spacing: 8,
              children: castToListString(widget.productModel
                      .supplementAttributes?['weight'] as List<dynamic>?)
                  .map(
                    (weight) => TChoiceChip(
                      text: weight,
                      selected: weight == selectedWeight,
                      onSelected: (value) {
                        setState(() {
                          selectedWeight = value ? weight : null;
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          ]
        ],
      ),
    );
  }
}
