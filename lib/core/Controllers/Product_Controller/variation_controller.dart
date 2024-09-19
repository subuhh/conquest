import 'package:conquest/core/Controllers/Product_Controller/product_image_controller.dart';
import 'package:conquest/core/model/Product_Models/product.dart';
import 'package:get/get.dart';
import '../../../../core/model/product_models/product_variations.dart';

class VariationController extends GetxController {
  static VariationController get instance => Get.find();

  final imageController = Get.put(ProductImageController());

  // Variables
  RxMap<String, String> selectedAttributes = <String, String>{}
      .obs; // Stores selected attributes like {'Color': 'Blue', 'Size': 'M'}
  Rx<ProductVariationModel> selectedVariation =
      ProductVariationModel.empty().obs;
  RxString variationStockStatus = ''.obs;
  RxString selectedAttributeSummary = ''.obs;
  RxString errorMessage = ''.obs;
  RxString variationPrice = ''.obs;

  // Initialize with the first variation's attributes
  void initializeSelectedAttributes(ProductModel product) {
    resetSelectedAttributes();

    if (product.productType == 'Single') {
      variationPrice.value =
          int.parse(product.salePrice) > 0 ? product.salePrice : product.price;
      imageController.selectedProductImage.value =
          product.thumbnail;
    }

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
      getVariationPrice(product);
      updateSelectedAttributeSummary(product);
      if (firstVariation.images.isNotEmpty) {
        imageController.selectedProductImage.value =
            firstVariation.images[0];
      } else {
        // Fallback to product thumbnail if no variation images are present
        imageController.selectedProductImage.value =
            product.thumbnail;
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
    getVariationPrice(product);
    updateSelectedAttributeSummary(product);
    getProductVariationStockStatus();

    // Update product image if the variation has images
    if (selectedVariation.value.images.isNotEmpty) {
      imageController.selectedProductImage.value =
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

  void getVariationPrice(ProductModel product) {
    if (product.productType == 'Single') {
      // Return the product's sale price for single products
      variationPrice.value =
          int.parse(product.salePrice) > 0 ? product.salePrice : product.price;
    } else {
      // Check if the selectedVariation exists and has valid prices
      if (selectedVariation.value.id.isEmpty ||
          selectedVariation.value.price == null) {
        // Return a default message or price if no valid variation is selected
        variationPrice.value = 'No Price Available';
      }

      // Check for salePrice and price, ensuring they are not null
      if (selectedVariation.value.salePrice != null &&
          int.parse(selectedVariation.value.salePrice!) > 0) {
        // Return salePrice if available and greater than 0
        variationPrice.value = selectedVariation.value.salePrice!;
      } else if (selectedVariation.value.price != null) {
        // Return price if salePrice is not available or invalid
        variationPrice.value = selectedVariation.value.price!;
      } else {
        // If neither price nor salePrice is available, return a default message
        variationPrice.value = product.salePrice;
      }
    }
  }

  void updateSelectedAttributeSummary(ProductModel product) {
    // Check if the product is of type 'Single'
    if (product.productType == 'Single') {
      // For single products, no need for variation attributes, so clear summary
      selectedAttributeSummary.value =
          ''; // Default empty format for single products
    } else {
      // For products with variations, format selected attributes
      List<String> selectedValues = [];

      // Add the selected values (e.g., "S", "Blue")
      selectedAttributes.forEach((attribute, value) {
        selectedValues.add(value); // Only add the attribute value, not the name
      });

      // Ensure there are always two values in the format (, value1, value2)
      while (selectedValues.length < 2) {
        selectedValues.insert(0, ''); // Add empty string for missing values
      }

      // Join the values with commas, ensuring the format starts with "(," and ends with ")"
      selectedAttributeSummary.value = ', ${selectedValues.join(', ')}';
    }
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
    variationPrice.value = '';
    selectedAttributeSummary.value = '';
    errorMessage.value = '';
  }
}
