import 'package:conquest/core/Controllers/Nutrition_Controller/recipe_controller.dart';
import 'package:conquest/core/model/Nutrition/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class PreviousRecipeScreen extends StatefulWidget {
  const PreviousRecipeScreen({super.key});

  @override
  _PreviousRecipeScreenState createState() => _PreviousRecipeScreenState();
}

class _PreviousRecipeScreenState extends State<PreviousRecipeScreen> {
  // Track expanded state for each recipe
  late List<bool> _isExpandedList;
  List<RecipeModel>? recipes;
  final recipeController = RecipeController.instance;

  @override
  void initState() {
    super.initState();
    // Initialize all recipes as collapsed
    recipes = recipeController.fetchedRecipesByIds;
    _isExpandedList = List.filled(recipes!.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delicious Recipes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.blue[700],
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[100]!,
              Colors.blue[50]!,
            ],
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          itemCount: recipes!.length,
          itemBuilder: (context, index) {
            final recipe = recipes![index];
            return _buildRecipeCard(recipe, index);
          },
        ),
      ),
    );
  }

  Widget _buildRecipeCard(RecipeModel recipe, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpandedList[index] = !_isExpandedList[index];
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      recipe.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    _isExpandedList[index]
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ],
              ),
            ),

            // Collapsed Content
            if (!_isExpandedList[index])
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildRecipeInfoChip(Icons.access_time, recipe.prepTime),
                    _buildRecipeInfoChip(Icons.restaurant, recipe.cuisine),
                    _buildRecipeInfoChip(Icons.restaurant_menu, recipe.course),
                  ],
                ),
              ),

            // Expanded Content
            if (_isExpandedList[index])
              Animate(
                effects: [FadeEffect(), SlideEffect()],
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Info Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildRecipeInfoChip(
                              Icons.access_time, recipe.prepTime),
                          _buildRecipeInfoChip(
                              Icons.restaurant, recipe.cuisine),
                          _buildRecipeInfoChip(
                              Icons.restaurant_menu, recipe.course),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Nutrition Info
                      Text(
                        'Nutrition Facts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (recipe.calories != null)
                            _buildNutritionChip('Calories', recipe.calories!),
                          if (recipe.protein != null)
                            _buildNutritionChip('Protein', recipe.protein!),
                          if (recipe.carbs != null)
                            _buildNutritionChip('Carbs', recipe.carbs!),
                          if (recipe.fat != null)
                            _buildNutritionChip('Fat', recipe.fat!),
                          if (recipe.fiber != null)
                            _buildNutritionChip('Fiber', recipe.fiber!),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Ingredients Section
                      Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: recipe.ingredients.map((ingredient) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.blue[700],
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    ingredient,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),

                      // Steps Section
                      Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: recipe.instructions.map((instruction) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.blue[700],
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    instruction,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      )
          .animate()
          .fade(duration: Duration(milliseconds: 300))
          .slideY(begin: 0.1, end: 0),
    );
  }

  // Helper widget for creating info chips
  Widget _buildRecipeInfoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blue[700],
            size: 16,
          ),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.blue[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for creating nutrition chips
  Widget _buildNutritionChip(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue[100]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: Colors.blue[700],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
