import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/Controllers/Nutrition_Controller/nutrition_controller.dart';
import '../../../../core/model/Nutrition/nutrition_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../Widgets/nutritron_fact_chart.dart';
import 'Widget/QuantityMeasurement Widget.dart';

class MealContentPage extends StatelessWidget {
  const MealContentPage({
    super.key,
    required this.foodData,
    required this.mealType,
  });

  final Map<String, dynamic> foodData; // Edamam food data
  final String mealType;

  @override
  Widget build(BuildContext context) {
    final nutritionController = NutritionController.instance;

    final nutritionDetails = {
      "Total Fat": "2.68g",
      "Saturated Fat": "0.54g",
      "Trans Fat": "0g",
      "Cholesterol": "0.00mg",
      "Sodium": "4.00mg",
      "Total Carbohydrate": "76.20g",
      "Dietary Fiber": "3.40g",
      "Total Sugars": "0g",
      "Protein": "7.50g",
      "Vitamin D": "0.00μg",
      "Calcium": "33.00mg",
      "Iron": "1.80mg",
      "Potassium": "268.00mg",
    };

    // Extract nutritional values from food data
    final String foodName = foodData['label'] ?? 'Unknown Food';
    final double totalCalories =
        foodData['nutrients']['ENERC_KCAL']?.toDouble() ?? 0.0;
    final double carbs = foodData['nutrients']['CHOCDF']?.toDouble() ?? 0.0;
    final double protein = foodData['nutrients']['PROCNT']?.toDouble() ?? 0.0;
    final double fat = foodData['nutrients']['FAT']?.toDouble() ?? 0.0;

    // Total macros for chart
    final totalMacros = {
      "Carbs": carbs,
      "Protein": protein,
      "Fat": fat,
    };

    return Scaffold(
      backgroundColor: TColors.secondaryBackground,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: CircleAvatar(
            radius: 17.5,
            backgroundColor: Colors.grey,
            child: CircleAvatar(
              radius: 17,
              backgroundColor: TColors.secondaryBackground,
              child: const Icon(
                Icons.arrow_back,
                size: 20,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Nutrition',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food Name and Image
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      foodName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (foodData['image'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: foodData['image'],
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Nutrition Facts Chart
              NutritionFactsChartWidget(
                macros: totalMacros,
              ),

              const SizedBox(height: TSizes.spaceBtwSections),
              // Quantity Measurement
              QuantityMeasureWidget(),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Nutrition Facts Widget
              NutritionFactsWidget(
                servingSize: "100 Gram",
                calories: totalCalories,
                nutritionDetails: nutritionDetails,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: TColors.primary),
          onPressed: () {
            // Prepare meal data
            final mealData = Meal(
              items: [foodName],
              totalCalories: totalCalories.toInt(),
              macros: {
                "carbG": carbs,
                "proteinG": protein,
                "fatG": fat,
              },
            );

            // Update the meal in the controller
            nutritionController.addOrUpdateMeal(
                mealType.toLowerCase(), mealData);
            Get.back();
          },
          child: Text(
            "Add to $mealType",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(fontWeightDelta: 2, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
