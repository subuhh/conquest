import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/Nutrition/recipe_model.dart';
import '../../model/user.dart';
import '../firestore_service.dart';

class RecipeService {
  final CollectionReference recipeCollection =
      FirebaseFirestore.instance.collection('Recipes');
  final firestoreService = FirestoreService();

  // Map user diet preferences to recipe categories
  final Map<String, List<String>> dietMapping = {
    'Vegetarian': ['Vegetarian', 'High Protein Vegetarian'],
    'Vegan': ['Vegan'],
    'Non-veg': ['Non Vegetarian', 'Eggetarian', 'High Protein Non Vegetarian'],
    'Dairy-Free': ['Vegan', 'Diabetic Friendly'],
    'Keto': ['Keto'],
    'Gluten-Free': ['Gluten Free'],
  };

  // Method to store recipe
  Future<String> storeRecipe(RecipeModel recipe) async {
    try {
      DocumentReference docRef = await recipeCollection.add(recipe.toMap());

      await recipeCollection.doc(docRef.id).update({'id': docRef.id});

      dev.log("Recipe stored successfully!");
      return docRef.id;
    } catch (e) {
      dev.log("Error storing recipe: $e");
      throw e;
    }
  }

  // Method to update user with generated recipe ID
  Future<void> updateUserWithGeneratedRecipe(
      String userId, String recipeId) async {
    try {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Retrieve the current list of recipes
      DocumentSnapshot userSnapshot = await userRef.get();
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      // Safely retrieve the previouslyGeneratedRecipes list
      List<dynamic> currentRecipes =
          userData?['previouslyGeneratedRecipes'] as List<dynamic>? ?? [];

      // Ensure only 5 recipes are stored
      if (currentRecipes.length >= 5) {
        currentRecipes.removeAt(0); // Remove the oldest recipe ID
      }

      // Add the new recipe ID
      currentRecipes.add(recipeId);

      // Update the user's previouslyGeneratedRecipes field with the new list
      await userRef.update({'previouslyGeneratedRecipes': currentRecipes});

      dev.log(
          "User updated with new recipe ID, maintaining a max of 5 recipes.");
    } catch (e) {
      dev.log("Error updating user with recipe: $e");
    }
  }

  // Fetch recipes by a list of IDs
  Future<List<RecipeModel>> getRecipesByIds(List<String> recipeIds) async {
    try {
      // Fetch all recipes matching the provided IDs
      QuerySnapshot querySnapshot = await recipeCollection
          .where(FieldPath.documentId, whereIn: recipeIds)
          .get();

      // Map the query results to RecipeModel objects
      List<RecipeModel> recipes = querySnapshot.docs
          .map((doc) => RecipeModel.fromDocument(doc))
          .toList();

      dev.log('Fetched ${recipes.length} recipes by IDs: $recipeIds');
      return recipes;
    } catch (e) {
      dev.log("Error fetching recipes by IDs: $e");
      return [];
    }
  }


  // Fetch recipes from Firestore based on user preferences
  Future<List<RecipeModel>> getRecommendedRecipes(
      String userUid, String mealType, int offset, int limit) async {
    // Fetch user details using UID
    UserModel? user = await firestoreService.getUserDetails(userUid);

    // Handle if user data is unavailable
    if (user == null) {
      return [];
    }

    // Retrieve diet preferences and calorie goal
    List<String> diets = user.dietPreference!;
    final calorieGoal = user.calorieGoal;
    dev.log('User Diet Preferences: $diets');
    dev.log('User Calorie Goal for a Meal: $calorieGoal');

    // Map user diet preferences to recipe categories
    List<String> allowedRecipeDiets = [];
    for (var diet in diets) {
      if (dietMapping.containsKey(diet)) {
        allowedRecipeDiets.addAll(dietMapping[diet]!);
      }
    }
    dev.log('Allowed Recipe Diets: $allowedRecipeDiets');

    // Fetch previously recommended recipes for the user
    List<String> previouslyRecommendedRecipeIds =
        await getUserPreviouslyRecommendedRecipes(userUid);

    // Fetch recipes from Firestore
    final querySnapshot = await recipeCollection.get();

    // Convert query snapshot to RecipeModel list
    List<RecipeModel> allRecipes =
        querySnapshot.docs.map((doc) => RecipeModel.fromDocument(doc)).toList();

    dev.log('All Recipes length: ${allRecipes.length}');

    // Exclude previously recommended recipes
    List<RecipeModel> newRecipes = allRecipes.where((recipe) {
      bool isPreviouslyRecommended =
          previouslyRecommendedRecipeIds.contains(recipe.id.toString());
      return !isPreviouslyRecommended;
    }).toList();

    dev.log('All Recipes length excluding previous: ${newRecipes.length}');

    // Filter recipes by strict diet preferences
    List<RecipeModel> filteredByDiet = newRecipes.where((recipe) {
      // Adjusted to check if `recipe.diet` (as a String) matches all user's diet preferences
      bool matchesAllDiets = diets.every(
          (userDiet) => dietMapping[userDiet]?.contains(recipe.diet) ?? false);
      return matchesAllDiets;
    }).toList();

    // Further filter recipes based on calorie goal
    List<RecipeModel> filteredByCalorie = filteredByDiet.where((recipe) {
      // Ensure calories is not null and can be parsed to an integer
      if (recipe.calories == null || recipe.calories!.isEmpty) {
        return false; // Exclude recipes without calorie information
      }
      try {
        int recipeCalories = int.parse(recipe.calories.toString());
        return recipeCalories <= calorieGoal!;
      } catch (e) {
        dev.log(
            'Error parsing calories for recipe: ${recipe.id}, ${recipe.calories}');
        return false; // Exclude if parsing fails
      }
    }).toList();

    // Prioritize high-protein recipes
    List<RecipeModel> highProteinRecipes = filteredByCalorie
        .where((recipe) => recipe.diet.contains(diets[0] == 'Vegetarian'
            ? allowedRecipeDiets[1]
            : allowedRecipeDiets[2]))
        .toList();

    List<RecipeModel> nonHighProteinRecipes = filteredByCalorie
        .where((recipe) => !recipe.diet.contains(diets[0] == 'Vegetarian'
            ? allowedRecipeDiets[1]
            : allowedRecipeDiets[2]))
        .toList();

    // Combine the high-protein recipes with the non-high-protein recipes, and shuffle the list
    List<RecipeModel> recommendedRecipes = [
      ...highProteinRecipes,
      ...nonHighProteinRecipes
    ];
    // recommendedRecipes.shuffle(Random());

    // Take the required number of recipes based on the offset and limit
    List<RecipeModel> paginatedRecipes =
        recommendedRecipes.skip(offset).take(limit).toList();

    // Store the recommended recipes for the user to avoid showing the same recipes again
    await storeUserRecommendedRecipes(
        userUid,
        paginatedRecipes.map((recipe) {
          return recipe.id.toString();
        }).toList());

    // dev.log the final recommended recipes
    dev.log('Recommended Recipes Count: ${paginatedRecipes.length}');
    return paginatedRecipes;
  }

  // Fetch previously recommended recipes for the user from Firestore
  Future<List<String>> getUserPreviouslyRecommendedRecipes(
      String userUid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userUid).get();
    final previouslyRecommendedRecipes =
        userDoc.data()?['previouslyRecommendedRecipes'] as List<dynamic>?;

    // Handle if there are no previously recommended recipes
    if (previouslyRecommendedRecipes == null) {
      return [];
    }

    final now = DateTime.now();
    List<Map<String, dynamic>> updatedRecipes = [];
    List<String> filteredRecipeIds = [];

    for (var entry in previouslyRecommendedRecipes) {
      if (entry is Map<String, dynamic>) {
        final timestamp = entry['timestamp'] as Timestamp?;
        if (timestamp == null) {
          // If timestamp is missing, add the current timestamp
          entry['timestamp'] = Timestamp.now();
          updatedRecipes.add(entry);
        } else {
          // Filter out recipes older than 3 days
          if (now.difference(timestamp.toDate()).inDays <= 3) {
            updatedRecipes.add(entry);
            filteredRecipeIds.add(entry['id'] as String);
          }
        }
      }
    }

    // Update Firestore with the new timestamps for recipes missing them
    await FirebaseFirestore.instance.collection('users').doc(userUid).update({
      'previouslyRecommendedRecipes': updatedRecipes,
    });

    return filteredRecipeIds;
  }

  // Store the recommended recipes for the user in Firestore
  Future<void> storeUserRecommendedRecipes(
      String userUid, List<String> recommendedRecipeIds) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userUid);
    final userSnapshot = await userDoc.get();

    // Get existing recommendations
    final existingRecommendations = (userSnapshot
            .data()?['previouslyRecommendedRecipes'] as List<dynamic>?) ??
        [];

    // Create a set of existing recipe IDs for quick lookup
    final existingRecipeIds =
        existingRecommendations.map((entry) => entry['id'] as String).toSet();

    // Create new recommendations with timestamp, ensuring uniqueness
    final newRecommendations = recommendedRecipeIds
        .where((id) => !existingRecipeIds.contains(id))
        .map((id) {
      return {
        'id': id,
        'timestamp': Timestamp.now(),
      };
    }).toList();

    // Combine existing and new recommendations
    final updatedRecommendations = existingRecommendations + newRecommendations;

    // Ensure the total recommendations do not exceed 100 entries
    if (updatedRecommendations.length > 100) {
      updatedRecommendations.sort((a, b) =>
          (a['timestamp'] as Timestamp).compareTo(b['timestamp'] as Timestamp));
      updatedRecommendations.removeRange(0, 20);
    }

    // Update Firestore with the new recommendations list
    await userDoc.update({
      'previouslyRecommendedRecipes': updatedRecommendations,
    });
  }
}
