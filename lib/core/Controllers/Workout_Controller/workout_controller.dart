import 'dart:developer';
import 'package:conquest/core/Controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../services/workout_service/workout_service.dart';
import '../../model/Workout/workout_model.dart';

class WorkoutController extends GetxController {
  static WorkoutController get instance => Get.find();

  final WorkoutService workoutService = WorkoutService();
  var currentDayWorkout = WorkoutDay.empty().obs;
  var currentDayWorkoutPlan = WorkoutPlan.empty().obs;
  var otherWorkoutPlans = <WorkoutPlan>[].obs; // List to store other workouts
  var isLoading = false.obs;

  void onInit() {
    super.onInit();
    final assignedPlanName =
        UserController.instance.userModel.value!.assignedWorkout;
    fetchWorkoutForToday(assignedPlanName!);
  }

  Future<void> fetchWorkoutForToday(String assignedPlanName) async {
    isLoading(true);
    try {
      // Fetch the assigned workout plan
      WorkoutPlan? workoutPlan =
          await workoutService.getWorkoutPlanById(assignedPlanName);

      if (workoutPlan != null) {
        currentDayWorkoutPlan.value = workoutPlan;

        // Map day_1, day_2, ... to weekdays
        Map<String, String> dayMapping = {
          "Day 1": "Monday",
          "Day 2": "Tuesday",
          "Day 3": "Wednesday",
          "Day 4": "Thursday",
          "Day 5": "Friday",
          "Day 6": "Saturday",
        };

        // Get the current weekday
        String currentWeekday = DateFormat('EEEE').format(DateTime.now());

        log('Current Week day $currentWeekday');

        // Find the workout for the current day
        WorkoutDay? todayWorkout = workoutPlan.days.firstWhere(
          (day) => dayMapping[day.day] == currentWeekday,
          orElse: () => WorkoutDay.empty(),
        );

        log('Current Day Workout: ${todayWorkout.totalTime}, ${todayWorkout.totalCalories}');

        currentDayWorkout.value = todayWorkout;
      } else {
        log("No workout plan found for user.");
        currentDayWorkout.value = WorkoutDay.empty();
      }
    } catch (e) {
      log("Error fetching today's workout: $e");
    } finally {
      isLoading(false);
    }
  }

  // Fetch all other workout plans except the assigned one
  Future<void> fetchOtherWorkoutPlans(String assignedPlanName) async {
    isLoading(true);
    try {
      // Fetch all workout plans
      List<WorkoutPlan> allWorkoutPlans =
          await workoutService.getAllWorkoutPlans();

      // Filter out the assigned workout plan from the list
      List<WorkoutPlan> filteredPlans = allWorkoutPlans
          .where(
            (plan) => plan.planName != assignedPlanName,
          )
          .toList();

      // Update the otherWorkoutPlans list with the filtered plans
      otherWorkoutPlans.value = filteredPlans;
      log("Fetched other workout plans.");
    } catch (e) {
      log("Error fetching other workout plans: $e");
    } finally {
      isLoading(false);
    }
  }
}
