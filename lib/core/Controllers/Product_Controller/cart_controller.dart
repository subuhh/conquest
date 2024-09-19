import 'dart:developer';

import 'package:conquest/core/Controllers/Product_Controller/variation_controller.dart';
import 'package:conquest/core/model/Product_Models/product.dart';
import 'package:conquest/core/model/cart_item.dart';
import 'package:conquest/utils/local_storage/storage_utility.dart';
import 'package:conquest/utils/popups/loaders.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  // Variables
  RxInt noOfCartItems = 0.obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxInt productQuantityInCart = 0.obs;
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final variationController = VariationController.instance;

  CartController() {
    loadCartItem();
  }

  void addToCart(ProductModel product) {
    // Quantity Check
    if (productQuantityInCart < 0) {
      TLoaders.customToast(message: 'Select Quantity');
      return;
    }

    // Variation Selected
    if (product.productType == 'Variation' &&
        variationController.selectedVariation.value.id.isEmpty) {
      TLoaders.customToast(message: 'Select Variation');
      return;
    }

    // Out of Stock Status
    if (product.productType == 'Variation') {
      if (int.parse(variationController.selectedVariation.value.stock!) < 1) {
        TLoaders.warningSnackBar(
            title: 'Oh Snap!', message: 'Selected Variation is out of stock');
      }
    } else {
      if (int.parse(product.stock) < 1) {
        TLoaders.warningSnackBar(
            title: 'Oh Snap!', message: 'Selected Product is out of stock');
      }
    }

    final selectedCartItem =
        convertToCartItem(product, productQuantityInCart.value);

    int index = cartItems.indexWhere((cartItem) =>
        cartItem.price == selectedCartItem.productId &&
        cartItem.variationId == selectedCartItem.variationId);

    if (index >= 0) {
      cartItems[index].quantity = selectedCartItem.quantity;
    } else {
      cartItems.add(selectedCartItem);
    }

    updateCart();
    TLoaders.customToast(message: 'Your Product has been added to Cart.');
  }

  // Convert product model into cart item model
  CartItemModel convertToCartItem(ProductModel product, int quantity) {
    if (product.productType == 'Single') {
      variationController.resetSelectedAttributes();
    }

    final variation = variationController.selectedVariation.value;
    final isVariation = variation.id.isNotEmpty;
    final price = isVariation
        ? int.parse(variation.salePrice!) > 0
            ? variation.salePrice!
            : variation.price!
        : int.parse(product.salePrice) > 0
            ? product.salePrice
            : product.price;

    return CartItemModel(
      title: product.title,
      price: price,
      productId: product.id,
      quantity: quantity,
      variationId: variation.id,
      image: isVariation ? variation.images[0] : product.thumbnail,
      selectedVariation: isVariation ? variation.attributeValues : null,
    );
  }

  void addOneToCart(CartItemModel item) {
    int index = cartItems.indexWhere((cartItem) =>
        cartItem.productId == item.productId &&
        cartItem.variationId == item.variationId);
    if (index >= 0) {
      cartItems[index].quantity += 1;
    } else {
      cartItems.add(item);
    }
    updateCart();
  }

  void removeOneToCart(CartItemModel item) {
    int index = cartItems.indexWhere((cartItem) =>
        cartItem.productId == item.productId &&
        cartItem.variationId == item.variationId);
    if (index >= 0) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
      } else {
        cartItems[index].quantity == 1
            ? removeCartItemDialog(index)
            : cartItems.removeAt(index);
      }
      updateCart();
    }
  }

  void removeCartItemDialog(int index) {
    Get.defaultDialog(
      title: 'Remove Product',
      middleText: 'Are you sure you want to remove this product?',
      onConfirm: () {
        cartItems.removeAt(index);
        updateCart();
        TLoaders.customToast(message: 'Product removed from the Cart.');
        Get.back();
      },
      onCancel: () => () => Get.back(),
    );
  }

  //  Update Cart Value
  void updateCart() {
    log('Update cart called');
    updateCartTotals();
    saveCartItems();
    cartItems.refresh();
  }

  void updateCartTotals() {
    double calculatedTotalPrice = 0.0;
    int calculatedNoOfItems = 0;

    for (var item in cartItems) {
      calculatedTotalPrice =
          double.parse(item.price) * item.quantity.toDouble();
      calculatedNoOfItems += item.quantity;
    }

    totalCartPrice.value = calculatedTotalPrice;
    log('Total Cart Price: ${totalCartPrice.value}');
    noOfCartItems.value = calculatedNoOfItems;
    log('No of items in Cart: ${noOfCartItems.value}');
  }

  void saveCartItems() {
    final cartItemStrings = cartItems.map((item) => item.toMap()).toList();
    TLocalStorage.instance().writeData('cartItems', cartItemStrings);
    log('save cart called storage is written');
    log('local storage called ${TLocalStorage.instance().readData<List<dynamic>>('cartItems')}');
  }

  void loadCartItem() {
    final cartItemStrings =
        TLocalStorage.instance().readData<List<dynamic>>('cartItems');
    if (cartItemStrings != null) {
      cartItems.assignAll(cartItemStrings.map(
          (item) => CartItemModel.fromFirestore(item as Map<String, dynamic>)));
      updateCartTotals();
    }
  }

  int getProductQuantityInCart(String productId) {
    final foundItem = cartItems.where((item) => item.productId == productId);
    // Sum the quantity of all matching items in the cart
    final totalQuantity = foundItem.fold(
        0, (previousValue, element) => previousValue + element.quantity);
    return totalQuantity;
  }

  int getVariationQuantityInCart(String productId, String variationId) {
    final foundItem = cartItems.firstWhere(
        (item) =>
            item.productId == productId && item.variationId == variationId,
        orElse: () => CartItemModel.empty());
    return foundItem.quantity;
  }

  void clearCart() {
    productQuantityInCart.value = 0;
    cartItems.clear();
    updateCart();
  }
}
