import 'dart:developer';

import 'package:get/get.dart';
import '../../model/Workout/workout_model.dart';
import '../../services/workout_service/workout_exercise_db_service.dart';

class ExerciseController extends GetxController {
  static ExerciseController get instance => Get.find();
  final ExerciseService exerciseService = ExerciseService();

  var exercises = [].obs;
  var isLoading = false.obs;

  Future<void> loadExercisesByBodyPart(String bodyPart) async {
    isLoading(true);
    try {
      exercises.value = await exerciseService
          .fetchExercisesByBodyPart(bodyPart.toLowerCase());
    } catch (e) {
      log('Unable to load exercise by body part: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadExercisesForCurrentDay(WorkoutDay workoutDay) async {
    isLoading(true);
    try {
      exercises.clear();
      // Fetch exercises using their names from ExerciseDB API
      exercises.value = await Future.wait(
        workoutDay.exercises.map((exercise) async {
          return await exerciseService.fetchExerciseByName(exercise.name.toLowerCase());
        }),
      );
    } catch (e) {
      log("Error loading exercises for current day: $e");
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }


  Future<void> loadAllExercises() async {
    isLoading(true);
    try {
      exercises.value = await exerciseService.fetchAllExercises();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadExercisesByTarget(String target) async {
    isLoading(true);
    try {
      exercises.value = await exerciseService.fetchExercisesByTarget(target);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadExercisesByName(String name) async {
    isLoading(true);
    try {
      exercises.value = await exerciseService.fetchExerciseByName(name.toLowerCase());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
