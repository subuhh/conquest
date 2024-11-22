import 'package:get/get.dart';
import '../../services/workout_service/workout_exercise_db_service.dart';

class ExerciseController extends GetxController {
  final ExerciseService exerciseService = ExerciseService();

  var exercises = [].obs;
  var isLoading = false.obs;

  Future<void> loadExercisesByBodyPart(String bodyPart) async {
    isLoading(true);
    try {
      exercises.value =
          await exerciseService.fetchExercisesByBodyPart(bodyPart);
    } catch (e) {
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
}
