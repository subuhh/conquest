import 'dart:convert';

import 'package:conquest/core/model/Product_Models/product.dart';
import 'package:conquest/core/model/cart_item.dart';
import 'package:conquest/core/repository/product_repository.dart';
import 'package:conquest/utils/local_storage/storage_utility.dart';
import 'package:conquest/utils/popups/loaders.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../../repository/favorite_repository.dart';
import 'cart_controller.dart';

class FavoriteController extends GetxController {
  static FavoriteController get instance => Get.find();

  final favorites = <String, bool>{}.obs;
  final _firebaseRepo = FavoriteRepository.instance;
  final CartController cartController = CartController.instance;

  @override
  void onInit() {
    super.onInit();
    syncFavorites();
  }

  Future<void> syncFavorites() async {
    final json = TLocalStorage.instance().readData('favorites');
    if (json != null) {
      final storedFavorites = jsonDecode(json) as Map<String, dynamic>;
      favorites.assignAll(
          storedFavorites.map((key, value) => MapEntry(key, value as bool)));
    }

    // Sync with Firebase favorites
    final firebaseFavorites = await _firebaseRepo.getFavoritesFromFirebase();
    favorites.assignAll(firebaseFavorites);
    saveFavoriteToStorage();
  }

  bool isFavorite(String productId) {
    return favorites[productId] ?? false;
  }

  void toggleFavoriteProduct(String productId) async {
    if (!favorites.containsKey(productId)) {
      favorites[productId] = true;
      await _firebaseRepo.addFavoriteToFirebase(productId);
      saveFavoriteToStorage();
      TLoaders.customToast(message: 'Product has been added to WishList.');
    } else {
      TLocalStorage.instance().removeData(productId);
      favorites.remove(productId);
      await _firebaseRepo.removeFavoriteFromFirebase(productId);
      saveFavoriteToStorage();
      favorites.refresh();
      TLoaders.customToast(message: 'Product has been removed to WishList.');
    }
    favorites.refresh();
  }

  void saveFavoriteToStorage() {
    final encodedFavorites = json.encode(favorites);
    TLocalStorage.instance().writeData('favorites', encodedFavorites);
  }

  Future<List<ProductModel>> favoriteProducts() async {
    return await ProductRepository.instance
        .getFavoriteProducts(favorites.keys.toList());
  }

  // Move item from Cart to Favorites
  void moveToFavoriteFromCart(CartItemModel item) {
    if (!isFavorite(item.productId)) {
      toggleFavoriteProduct(item.productId);
    }
    cartController.removeProductFromCart(item);

    favorites.refresh();
  }

  // Show confirmation dialog before moving the item
  void showMoveToFavoriteDialog(CartItemModel item) {
    Get.defaultDialog(
      title: 'Move to Wishlist',
      middleText: 'Are you sure you want to move this item to your Wishlist?',
      confirmTextColor: TColors.white,
      buttonColor: TColors.primary,
      onConfirm: () {
        moveToFavoriteFromCart(item);
        Get.back();
      },
      onCancel: () => Get.back(),
    );
  }
}
