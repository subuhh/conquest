import 'package:conquest/common/widgets/SectionHeading.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:conquest/features/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import '../../../../../common/widgets/chips/choice_chip.dart';
import '../../../../core/model/Product_Models/product.dart';

class ProductAttributes extends StatefulWidget {
  final ProductModel productModel;
  const ProductAttributes({super.key, required this.productModel});

  @override
  State<ProductAttributes> createState() => _ProductAttributesState();
}

class _ProductAttributesState extends State<ProductAttributes> {
  Map<String, String?> selectedAttributes = {};

  @override
  Widget build(BuildContext context) {
    List<String> castToListString(List<dynamic>? list) {
      if (list == null) return [];
      return list.map((item) => item.toString()).toList();
    }

    return Padding(
      padding: const EdgeInsets.only(left: TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.productModel.productAttributes?.map((attribute) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Sectionheading(
                title: 'Select ${attribute.name}',
                showActionButton: false,
              ),
              const SizedBox(
                height: TSizes.spaceBtwItems / 2,
              ),
              Wrap(
                spacing: 8,
                children: castToListString(attribute.values)
                    .map(
                      (value) => TChoiceChip(
                    text: THelperFunctions.capitalizeFirstLetter(value),
                    selected: selectedAttributes[attribute.name] == value,
                    onSelected: (isSelected) {
                      setState(() {
                        selectedAttributes[attribute.name!] = isSelected ? value : null;
                      });
                    },
                  ),
                )
                    .toList(),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 1.5),
            ],
          );
        }).toList() ?? [],
      ),
    );
  }
}
