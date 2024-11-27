import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conquest/core/Controllers/Nutrition_Controller/nutrition_controller.dart';
import '../../model/Nutrition/nutrition_model.dart';

class NutritionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add or update a meal for a specific user and meal type
  Future<void> addOrUpdateNutrition(
      String userId, String mealType, Meal mealData) async {
    try {
      final date = DateTime.now();
      final docId = _formatDateKey(date);
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('calorieIntake')
          .doc(docId);

      final mealMap = mealData.toMap();

      // Check if the document exists
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Update the specific meal in the existing document
        await docRef.update({
          "$mealType.items": FieldValue.arrayUnion(mealMap['items']),
          "$mealType.totalCalories":
              FieldValue.increment(mealData.totalCalories),
          "$mealType.macros": _updateMacros(
              docSnapshot.data()?[mealType]['macros'] ?? {}, mealData.macros),
        });
      } else {
        // Create a new document if it doesn't exist
        final newCalorieIntake = CalorieIntake(
          breakfast: mealType == "breakfast"
              ? Meal.fromMap(mealMap)
              : Meal(items: [], totalCalories: 0, macros: {}),
          morningSnack: mealType == "morningsnack"
              ? Meal.fromMap(mealMap)
              : Meal(items: [], totalCalories: 0, macros: {}),
          lunch: mealType == "lunch"
              ? Meal.fromMap(mealMap)
              : Meal(items: [], totalCalories: 0, macros: {}),
          eveningSnack: mealType == "eveningsnack"
              ? Meal.fromMap(mealMap)
              : Meal(items: [], totalCalories: 0, macros: {}),
          dinner: mealType == "dinner"
              ? Meal.fromMap(mealMap)
              : Meal(items: [], totalCalories: 0, macros: {}),
        );

        await docRef.set(newCalorieIntake.toMap());
      }
    } catch (e) {
      throw Exception("Error adding/updating nutrition: $e");
    }
  }

  /// Fetch all meals for a user
  Future<Map<String, Meal>> getMeals(
      String userId, DateTime? targetDate) async {
    try {
      final date = targetDate ?? DateTime.now();
      final docId = _formatDateKey(date);
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('calorieIntake')
          .doc(docId);

      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        return {};
      }

      final data = docSnapshot.data();

      // Return meal data directly, assuming the structure has top-level meal timings
      return {
        'breakfast': Meal.fromMap(data?['breakfast'] ?? {}),
        'morningsnack': Meal.fromMap(data?['morningsnack'] ?? {}),
        'lunch': Meal.fromMap(data?['lunch'] ?? {}),
        'eveningsnack': Meal.fromMap(data?['eveningsnack'] ?? {}),
        'dinner': Meal.fromMap(data?['dinner'] ?? {}),
      };
    } catch (e) {
      throw Exception("Error fetching meals: $e");
    }
  }

  /// Remove a meal item for a specific user and meal type
  Future<void> removeMeal(
      String userId, String mealType, String itemName) async {
    try {
      final nutritionController = NutritionController.instance;
      final date = DateTime.now();
      final docId = _formatDateKey(date);
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('calorieIntake')
          .doc(docId);

      // Check if the document exists
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final mealData = data?[mealType];
        if (mealData != null) {
          final items = List<String>.from(mealData['items']);
          // final macros = Map<String, double>.from(mealData['macros']);
          // final totalCalories = mealData['totalCalories'];

          // Log existing items and the item to remove
          print("Firestore items: $items");
          print("Item to remove: $itemName");

          // Check if the item exists in the list
          if (items.contains(itemName)) {
            items.remove(itemName);

            // Map controller macro names to Firestore macro names
            final updatedMacros = {
              "proteinG": NutritionController.instance.mealMacros[mealType]
                      ?["protein"] ??
                  0.0,
              "fatG": NutritionController.instance.mealMacros[mealType]
                      ?["fat"] ??
                  0.0,
              "carbG": NutritionController.instance.mealMacros[mealType]
                      ?["carbs"] ??
                  0.0,
            };

            await docRef.update({
              "$mealType.items": items,
              "$mealType.totalCalories":
                  nutritionController.mealCalories[mealType]?.value,
              "$mealType.macros": updatedMacros,
            });

            print("Item removed successfully");
          } else {
            print("The item does not exist in the current Firestore items.");
          }
        } else {
          print("Meal type data does not exist.");
        }
      } else {
        print("Document does not exist.");
      }
    } catch (e) {
      throw Exception("Error removing meal: $e");
    }
  }

  /// Invert macros for subtraction
  // Map<String, dynamic> _invertMacros(Map<String, dynamic> macros) {
  //   final invertedMacros = <String, dynamic>{};
  //
  //   macros.forEach((key, value) {
  //     invertedMacros[key] = -value; // Subtracting macros
  //   });
  //
  //   return invertedMacros;
  // }

  /// Format date for document ID
  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Update macros by merging existing and new values
  Map<String, dynamic> _updateMacros(
      Map<String, dynamic> currentMacros, Map<String, dynamic> newMacros) {
    final updatedMacros = Map<String, dynamic>.from(currentMacros);

    newMacros.forEach((key, value) {
      updatedMacros[key] = (updatedMacros[key] ?? 0) + value;
    });

    return updatedMacros;
  }

  /// Invert macros for subtraction
  // Map<String, dynamic> _invertMacros(Map<String, dynamic> macros) {
  //   final invertedMacros = <String, dynamic>{};
  //
  //   macros.forEach((key, value) {
  //     invertedMacros[key] = -value;
  //   });
  //
  //   return invertedMacros;
  // }
}
