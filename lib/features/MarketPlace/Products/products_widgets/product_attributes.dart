import 'package:conquest/common/widgets/SectionHeading.dart';
import 'package:conquest/features/utils/constants/sizes.dart';
import 'package:conquest/features/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/chips/choice_chip.dart';
import '../../../../core/Controllers/Product_Controller/variation_controller.dart';
import '../../../../core/model/Product_Models/product.dart';

class ProductAttributes extends StatefulWidget {
  final ProductModel productModel;
  const ProductAttributes({super.key, required this.productModel});

  @override
  State<ProductAttributes> createState() => _ProductAttributesState();
}

class _ProductAttributesState extends State<ProductAttributes> {
  final variationController = VariationController.instance;



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.productModel.productAttributes!.map((attribute) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: TSizes.defaultSpace / 2),
              Sectionheading(
                title: '${attribute.name}',
                showActionButton: false,
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              Obx(() {
                // Get available attribute values based on other selections
                Set<String> availableAttributeValues =
                    variationController.getAvailableAttributeValues(
                        widget.productModel, attribute.name!);

                return Wrap(
                  spacing: 8,
                  children: attribute.values!.map((value) {
                    bool isAvailable = availableAttributeValues.contains(value);
                    bool isSelected = variationController
                            .selectedAttributes[attribute.name] ==
                        value;

                    return TChoiceChip(
                      text: THelperFunctions.capitalizeFirstLetter(value),
                      selected: isSelected,
                      onSelected: isAvailable
                          ? (isSelected) {
                              variationController.onAttributeSelected(
                                  widget.productModel, attribute.name!, value);
                            }
                          : null, // If not available, disable interaction
                    );
                  }).toList(),
                );
              }),
            ],
          );
        }).toList(),
      ),
    );
  }
}
