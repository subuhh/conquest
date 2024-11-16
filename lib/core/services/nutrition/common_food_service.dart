import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../model/Nutrition/common_food_model.dart';

class NutritionService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch nutrition data from Firestore
  Future<List<NutritionItem>> fetchNutritionData() async {
    try {
      QuerySnapshot snapshot =
      await _firestore.collection('common_food').get();
      return snapshot.docs
          .map((doc) => NutritionItem.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log("Error fetching data: $e");
      return [];
    }
  }
}
