import 'dart:developer';
import 'package:conquest/core/Controllers/Product_Controller/variation_controller.dart';
import 'package:conquest/core/model/Product_Models/product.dart';
import 'package:conquest/core/model/cart_item.dart';
import 'package:conquest/utils/constants/colors.dart';
import 'package:conquest/utils/local_storage/storage_utility.dart';
import 'package:conquest/utils/popups/loaders.dart';
import 'package:get/get.dart';
import '../../repository/cart_repository.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  // Dependencies
  final CartRepository _cartRepository = CartRepository();
  final variationController = VariationController.instance;

  // Variables
  RxInt noOfCartItems = 0.obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxInt productQuantityInCart = 0.obs;
  RxInt productQuantity = 1.obs;
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  CartController() {
    loadCartItem();
    syncFirebaseCart();
  }

  void addToCart(ProductModel product) {
    // Quantity Check
    if (productQuantity < 0) {
      TLoaders.customToast(message: 'Select Quantity');
      return;
    }

    // Variation Selected
    if (product.productType == 'Variation' &&
        variationController.selectedVariation.value.vid.isEmpty) {
      TLoaders.customToast(message: 'Select Variation');
      return;
    }

    // Out of Stock Status
    if (product.productType == 'Variation') {
      if (int.parse(variationController.selectedVariation.value.stock) < 1) {
        TLoaders.warningSnackBar(
            title: 'Oh Snap!', message: 'Selected Variation is out of stock');
      }
    } else {
      if (int.parse(product.stock) < 1) {
        TLoaders.warningSnackBar(
            title: 'Oh Snap!', message: 'Selected Product is out of stock');
      }
    }

    final count;

    if (product.productType == 'Single') {
      count = getProductQuantityInCart(product.id);
    } else {
      count = getVariationQuantityInCart(
          product.id, variationController.selectedVariation.value.vid);
    }

    final selectedCartItem =
        convertToCartItem(product, count + productQuantity.value);

    int index = cartItems.indexWhere((cartItem) =>
        cartItem.productId == selectedCartItem.productId &&
        cartItem.variationId == selectedCartItem.variationId);

    if (index >= 0) {
      cartItems[index].quantity = selectedCartItem.quantity;
      TLoaders.customToast(message: 'Your Product Quantity has been updated.');
      if (product.productType == 'Single') {
        _cartRepository.updateCartItemQuantity(
            selectedCartItem.productId, cartItems[index].quantity);
      } else {
        _cartRepository.updateCartItemQuantity(
            selectedCartItem.variationId, cartItems[index].quantity);
      }
    } else {
      cartItems.add(selectedCartItem);
      TLoaders.customToast(message: 'Your Product has been added to Cart.');
      // if (product.productType == 'Single') {
      _cartRepository.addItemToCart(selectedCartItem);
      // } else {
      //   _cartRepository.addItemToCart(selectedCartItem);
      // }
    }

    updateCart();
  }

  // Convert product model into cart item model
  CartItemModel convertToCartItem(ProductModel product, int quantity) {
    if (product.productType == 'Single') {
      variationController.resetSelectedAttributes();
    }

    final variation = variationController.selectedVariation.value;
    final isVariation = variation.vid.isNotEmpty;
    final price = isVariation
        ? int.parse(variation.salePrice!) > 0
            ? variation.salePrice!
            : variation.price
        : int.parse(product.salePrice) > 0
            ? product.salePrice
            : product.price;

    return CartItemModel(
      title: product.title,
      price: price,
      productId: product.id,
      quantity: quantity,
      variationId: variation.vid,
      image: isVariation
          ? variation.images!.isNotEmpty
              ? variation.images![0]
              : product.thumbnail
          : product.thumbnail,
      selectedVariation: isVariation ? variation.attributeValues : null,
    );
  }

  void addOneToCart(CartItemModel item) {
    int index = cartItems.indexWhere((cartItem) =>
        cartItem.productId == item.productId &&
        cartItem.variationId == item.variationId);
    if (index >= 0) {
      cartItems[index].quantity += 1;
      if (item.variationId.isNotEmpty && item.selectedVariation != null) {
        _cartRepository.updateCartItemQuantity(
            item.variationId, cartItems[index].quantity);
      } else {
        _cartRepository.updateCartItemQuantity(
            item.productId, cartItems[index].quantity);
      }
    } else {
      cartItems.add(item);
      _cartRepository.addItemToCart(item);
      TLoaders.customToast(message: 'Your Product has been added to Cart.');
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
        if (item.variationId.isNotEmpty && item.selectedVariation != null) {
          _cartRepository.updateCartItemQuantity(
              item.variationId, cartItems[index].quantity);
        } else {
          _cartRepository.updateCartItemQuantity(
              item.productId, cartItems[index].quantity);
        }
      } else {
        cartItems[index].quantity == 1
            ? removeCartItemDialog(index, item)
            : cartItems.removeAt(index);
        // removeCartItem(index);
      }
      updateCart();
    }
  }

  void removeCartItem(int index, CartItemModel item) {
    removeCartItemDialog(index, item);
    updateCart();
  }

  // Remove product from cart by product ID
  void removeProductFromCart(CartItemModel cartItem) {
    if (cartItem.variationId.isNotEmpty && cartItem.selectedVariation != null) {
      cartItems.removeWhere((item) => item.variationId == cartItem.variationId);
      _cartRepository.removeItemFromCart(cartItem.variationId);
    } else {
      cartItems.removeWhere((item) => item.productId == cartItem.productId);
      _cartRepository.removeItemFromCart(cartItem.productId);
    }

    updateCart();
    TLoaders.customToast(message: 'Product added in Wishlist.');
  }

  void removeCartItemDialog(int index, CartItemModel item) {
    Get.defaultDialog(
      confirmTextColor: TColors.white,
      buttonColor: TColors.primary,
      title: 'Remove Product',
      middleText: 'Are you sure you want to remove this product?',
      onConfirm: () {
        cartItems.removeAt(index);
        if (item.variationId.isNotEmpty && item.selectedVariation != null) {
          _cartRepository.removeItemFromCart(item.variationId);
        } else {
          _cartRepository.removeItemFromCart(item.productId);
        }

        updateCart();
        TLoaders.customToast(message: 'Product removed from the Cart.');
        Get.back();
      },
      onCancel: () => () => Get.back(),
    );
  }

  void updateAlreadyAddedProductCount(ProductModel product) {
    productQuantity.value = 1;
    if (product.productType == 'Single') {
      productQuantityInCart.value = getProductQuantityInCart(product.id);
    } else {
      final variationId = variationController.selectedVariation.value.vid;
      if (variationId.isNotEmpty) {
        productQuantityInCart.value =
            getVariationQuantityInCart(product.id, variationId);
      } else {
        productQuantityInCart.value = 0;
      }
    }
  }

  //  Update Cart Value
  void updateCart() {
    log('Update cart called');
    updateCartTotals();
    saveCartItems();
    cartItems.refresh();
  }

  void updateCartTotals() {
    int calculatedTotalPrice = 0;
    int calculatedNoOfItems = 0;

    for (var item in cartItems) {
      calculatedTotalPrice += int.parse(item.price) * item.quantity.toInt();
      calculatedNoOfItems += item.quantity;
    }

    totalCartPrice.value = calculatedTotalPrice.toDouble();
    log('Total Cart Price: ${totalCartPrice.value}');
    noOfCartItems.value = calculatedNoOfItems;
    log('No of items in Cart: ${noOfCartItems.value}');
  }

  void saveCartItems() {
    final cartItemStrings = cartItems.map((item) => item.toMap()).toList();
    TLocalStorage.instance().writeData('cartItems', cartItemStrings);
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

  Future<void> syncFirebaseCart() async {
    final firebaseCartItems = await _cartRepository.getCartItems();
    cartItems.assignAll(firebaseCartItems);
    updateCartTotals();
    saveCartItems(); // Save in local storage after syncing with Firebase
  }

  void clearCart() {
    productQuantityInCart.value = 0;
    productQuantity.value = 0;
    cartItems.clear();
    updateCart();
  }
}
