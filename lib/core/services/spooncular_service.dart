import 'dart:convert';
import 'package:http/http.dart' as http;

class SpoonacularService {
  static const String _apiKey = '6e02eb223ea0496ba1692c643dbf6166';
  static const String _baseUrl = 'https://api.spoonacular.com';

  Future<Map<String, dynamic>> getMealPlan(
      {required String diet, required int numMeals}) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/mealplanner/generate?timeFrame=day&diet=$diet&number=$numMeals&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load meal plan');
    }
  }

  Future<List<dynamic>> getRecipesByIngredients(
    List<String> ingredients,
    int numberOfRecipes,
  ) async {
    final ingredientString = ingredients.join(',');
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/recipes/findByIngredients?ingredients=$ingredientString&number=$numberOfRecipes&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<List<dynamic>> getRecipes({
    required String diet,
    required int maxCalories,
    required String mealType, // 'breakfast', 'lunch', or 'dinner'
    required int numberOfRecipes,
  }) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/recipes/complexSearch?diet=$diet&maxCalories=$maxCalories&number=$numberOfRecipes&type=$mealType&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  // Fetch detailed recipe information by recipe id
  Future<Map<String, dynamic>> getRecipeDetails(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/recipes/$id/information?apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recipe details');
    }
  }
}
