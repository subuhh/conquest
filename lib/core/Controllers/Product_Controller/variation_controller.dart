import 'package:conquest/core/Controllers/Product_Controller/product_image_controller.dart';
import 'package:conquest/core/model/Product_Models/product.dart';
import 'package:get/get.dart';
import '../../../../core/model/product_models/product_variations.dart';

class VariationController extends GetxController {
  static VariationController get instance => Get.find();

  // Variables
  RxMap<String, String> selectedAttributes = <String, String>{}
      .obs; // Stores selected attributes like {'Color': 'Blue', 'Size': 'M'}
  Rx<ProductVariationModel> selectedVariation =
      ProductVariationModel.empty().obs;
  RxString variationStockStatus = ''.obs;
  RxString selectedAttributeSummary = ''.obs;
  RxString errorMessage = ''.obs;

  // Initialize with the first variation's attributes
  void initializeSelectedAttributes(ProductModel product) {
    resetSelectedAttributes();
    if (product.productVariations != null &&
        product.productVariations!.isNotEmpty) {
      ProductVariationModel firstVariation = product.productVariations![0];

      // Set selectedAttributes to the first variation's attribute values
      selectedAttributes.value =
          Map<String, String>.from(firstVariation.attributeValues);

      // Set the first variation as the selected variation
      selectedVariation.value = firstVariation;

      // Update product image and stock status
      getProductVariationStockStatus();
      getVariationPrice();
      updateSelectedAttributeSummary();
      if (firstVariation.images.isNotEmpty) {
        ProductImageController.instance.selectedProductImage.value =
            firstVariation.images[0];
      }

      errorMessage.value = ''; // Clear any previous errors
    } else {
      // Handle case when there are no variations
      errorMessage.value = 'No variations available for this product.';
    }
  }

  // Step 2: When an attribute is selected by the user, update the selected attribute and dynamically adjust the remaining options
  void onAttributeSelected(
      ProductModel product, String attributeName, String attributeValue) {
    selectedAttributes[attributeName] = attributeValue;

    // Step 3: Dynamically adjust other attributes based on the selected attribute
    ProductVariationModel? matchedVariation = _findMatchingVariation(product);

    if (matchedVariation != null) {
      selectedVariation.value = matchedVariation;
      getProductVariationStockStatus();
      errorMessage.value = '';
    } else {
      // Step 4: Automatically update the other attribute to a valid combination
      _adjustOtherAttributesToValidVariation(
          product, attributeName, attributeValue);
    }
    // Update the summary text
    updateSelectedAttributeSummary();

    // Update product image if the variation has images
    if (selectedVariation.value.images.isNotEmpty) {
      ProductImageController.instance.selectedProductImage.value =
          selectedVariation.value.images[0];
    }
  }

  // Adjust other attributes to find a valid variation when an invalid combination is selected
  void _adjustOtherAttributesToValidVariation(ProductModel product,
      String selectedAttributeName, String selectedAttributeValue) {
    for (ProductVariationModel variation in product.productVariations!) {
      if (variation.attributeValues[selectedAttributeName] ==
          selectedAttributeValue) {
        // Automatically adjust the other attributes to the valid values of this variation
        variation.attributeValues.forEach((key, value) {
          if (key != selectedAttributeName) {
            selectedAttributes[key] = value;
          }
        });
        selectedVariation.value = variation;
        getProductVariationStockStatus();
        break;
      }
    }
  }

  // Step 5: Get available attribute values based on current selections but always show attributes available in variations
  Set<String> getAvailableAttributeValues(
      ProductModel product, String attributeName) {
    Set<String> availableValues = {};

    for (ProductVariationModel variation in product.productVariations!) {
      availableValues.add(variation.attributeValues[attributeName]!);
    }

    return availableValues;
  }

  // Find matching variation based on selected attributes
  ProductVariationModel? _findMatchingVariation(ProductModel product) {
    for (ProductVariationModel variation in product.productVariations!) {
      bool isMatch = true;

      selectedAttributes.forEach((key, value) {
        if (variation.attributeValues[key] != value) {
          isMatch = false;
        }
      });

      if (isMatch) {
        return variation;
      }
    }
    return null;
  }

  String getVariationPrice() {
    return int.parse(selectedVariation.value.salePrice!) > 0
        ? selectedVariation.value.salePrice!
        : selectedVariation.value.price!;
  }

  void updateSelectedAttributeSummary() {
    // Build a string with only the selected attribute values
    List<String> selectedValues = [];

    // Only add the values (e.g., "Blue", "S")
    selectedAttributes.forEach((attribute, value) {
      selectedValues.add(value); // Only add the attribute value, not the name
    });

    // Join the values with commas and update the summary
    selectedAttributeSummary.value = selectedValues.join(', ');
  }

  // Get the stock status of the selected variation
  void getProductVariationStockStatus() {
    if (selectedVariation.value.id.isEmpty) {
      variationStockStatus.value = 'No Variation Selected';
    } else {
      int stock = int.parse(selectedVariation.value.stock!);
      variationStockStatus.value = stock > 0 ? 'In Stock' : 'Out of Stock';
    }
  }

  // Reset selected attributes when switching products
  void resetSelectedAttributes() {
    selectedAttributes.clear();
    variationStockStatus.value = '';
    selectedVariation.value = ProductVariationModel.empty();
    errorMessage.value = '';
  }
}
