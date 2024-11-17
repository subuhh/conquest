import 'package:conquest/core/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/local_storage/storage_utility.dart';
import '../../../utils/popups/loaders.dart';

class RecipeFavoriteController extends GetxController {
  static RecipeFavoriteController get instance => Get.find();

  var favoriteRecipes =
      <Map<String, dynamic>>[].obs; // Observable list for favorite recipes

  final _db = FirebaseFirestore.instance;

  // Fetch favorite recipes from Firestore
  Future<void> fetchFavoriteRecipes() async {
    final userId = AuthService.instance.currentUser!.uid;
    final querySnapshot =
        await _db.collection('users').doc(userId).collection('favorites').get();
    favoriteRecipes.assignAll(querySnapshot.docs.map((doc) => doc.data()));
  }

  // Save a recipe to favorites
  Future<void> saveRecipeToFavorites(
      String userId, Map<String, dynamic> recipe) async {
    if (favoriteRecipes.any((r) => r['id'] == recipe['id']))
      return; // Prevent duplicates

    // Add recipe to Firestore
    await _db
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(recipe['id'].toString())
        .set(recipe);

    // Update local storage
    await TLocalStorage.instance()
        .writeData('favoriteRecipes', favoriteRecipes);
    favoriteRecipes.add(recipe); // Update the observable list
  }

  // Remove a recipe from favorites
  Future<void> removeRecipeFromFavorites(String userId, String recipeId) async {
    // Remove from Firestore
    await _db
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(recipeId)
        .delete();

    // Update local storage
    favoriteRecipes.removeWhere(
        (recipe) => recipe['id'] == recipeId); // Remove from observable list
    await TLocalStorage.instance()
        .writeData('favoriteRecipes', favoriteRecipes);
  }

  // Toggle favorite status
  Future<void> toggleFavorite(
      String userId, Map<String, dynamic> recipe) async {
    if (favoriteRecipes.any((r) => r['id'] == recipe['id'])) {
      await removeRecipeFromFavorites(userId, recipe['id']);
      TLoaders.customToast(
          message: 'Recipe has been removed to Favourite Recipe.');
    } else {
      await saveRecipeToFavorites(userId, recipe);
      TLoaders.customToast(
          message: 'Recipe has been added to Favourite Recipe.');
    }
  }
}
