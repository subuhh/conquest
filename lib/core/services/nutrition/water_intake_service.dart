import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/Nutrition/water_intake_model.dart';

class WaterIntakeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch water intake data for a specific user and date
  Future<WaterIntakeModel?> getWaterIntake(String userId, DateTime date) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('waterIntake')
          .doc(_formatDateKey(date)); // Use formatted date as document ID

      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        return WaterIntakeModel.fromMap(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching water intake: $e');
    }
  }

  // Create or update water intake data
  Future<void> setWaterIntake(
      String userId, WaterIntakeModel waterIntake) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('waterIntake')
          .doc(_formatDateKey(waterIntake.date)); // Use formatted date as document ID

      await docRef.set(waterIntake.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error saving water intake: $e');
    }
  }

  // Update water goal and its unit
  Future<void> updateWaterGoal(
      String userId, double goal, String unit) async {
    try {
      final userDocRef = _firestore.collection('users').doc(userId);
      await userDocRef.set(
        {'waterGoal': {'amount': goal, 'unit': unit}},
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Error updating water goal: $e');
    }
  }

  // Helper method to format date as a key (e.g., "yyyy-MM-dd")
  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
