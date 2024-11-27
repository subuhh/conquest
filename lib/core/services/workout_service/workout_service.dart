import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/Workout/workout_model.dart';

class WorkoutService {
  Future<void> storeWorkoutPlans(
      List<Map<String, dynamic>> workoutPlans) async {
    try {
      // Reference to the Firestore collection
      final CollectionReference workoutCollection =
          FirebaseFirestore.instance.collection('WorkoutPlan');

      // Iterate through each plan and add it as a document
      for (var plan in workoutPlans) {
        // Ensure plan name is a string
        String planName = plan['plan_name'] ?? 'unknown_plan';

        WorkoutPlan workout = WorkoutPlan.fromJson(plan);

        await workoutCollection.doc(planName).set(workout.toJson());
      }
      log("Workout plans stored successfully with custom IDs!");
    } catch (e) {
      log("Error storing workout plans: $e");
    }
  }

  // Fetch a workout plan by its ID (plan_name)
  Future<WorkoutPlan?> getWorkoutPlanById(String planName) async {
    try {
      final CollectionReference workoutCollection =
          FirebaseFirestore.instance.collection('WorkoutPlan');

      // Fetch the document by its ID
      DocumentSnapshot snapshot = await workoutCollection.doc(planName).get();

      // Check if the document exists
      if (snapshot.exists) {
        // Deserialize the document into a WorkoutPlan object
        return WorkoutPlan.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        log("Workout plan not found for ID: $planName");
        return null;
      }
    } catch (e) {
      log("Error fetching workout plan by ID: $e");
      return null;
    }
  }

  // Fetch all workout plans
  Future<List<WorkoutPlan>> getAllWorkoutPlans() async {
    try {
      final CollectionReference workoutCollection =
          FirebaseFirestore.instance.collection('WorkoutPlan');

      // Fetch all documents in the collection
      QuerySnapshot snapshot = await workoutCollection.get();

      // Deserialize each document into a WorkoutPlan object
      List<WorkoutPlan> workoutPlans = snapshot.docs.map((doc) {
        return WorkoutPlan.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return workoutPlans;
    } catch (e) {
      log("Error fetching all workout plans: $e");
      return [];
    }
  }
}
