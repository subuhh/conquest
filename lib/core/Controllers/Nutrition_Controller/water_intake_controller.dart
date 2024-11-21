import 'package:conquest/core/Controllers/user_controller.dart';
import 'package:get/get.dart';
import '../../model/Nutrition/water_intake_model.dart';
import '../../services/auth_service.dart';
import '../../services/nutrition/water_intake_service.dart';

class WaterIntakeController extends GetxController {
  static WaterIntakeController get instance => Get.find();

  final WaterIntakeService _waterIntakeService = WaterIntakeService();
  String userId = AuthService.instance.currentUser!.uid;

  Rx<WaterIntakeModel?> waterIntake = Rx<WaterIntakeModel?>(null);
  RxDouble waterGoal = 0.0.obs; // Default goal in ml
  RxString waterGoalUnit = 'L'.obs; // Default unit
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeTodayWaterIntake(AuthService.instance.currentUser!.uid);
  }

  // Fetch water intake data for a specific user and date
  Future<void> fetchWaterIntake(DateTime date) async {
    isLoading.value = true;
    try {
      final result = await _waterIntakeService.getWaterIntake(userId, date);
      waterIntake.value = result;
    } catch (e) {
      print('Error fetching water intake: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Add a water entry and update the water goal progress
  Future<void> addWaterEntry(String userId, double amount) async {
    if (waterIntake.value != null) {
      final updatedWaterIntake = waterIntake.value!;
      updatedWaterIntake.entries
          .add(WaterEntry(time: DateTime.now(), amount: amount));
      updatedWaterIntake.totalIntake += amount;

      // Reassign the reactive variable
      waterIntake.value = WaterIntakeModel(
        date: updatedWaterIntake.date,
        totalIntake: updatedWaterIntake.totalIntake,
        entries: updatedWaterIntake.entries,
      );

      await _waterIntakeService.setWaterIntake(userId, updatedWaterIntake);
    }
  }

  // Remove the last water entry
  Future<void> removeWaterEntry(String userId) async {
    if (waterIntake.value != null && waterIntake.value!.entries.isNotEmpty) {
      final updatedWaterIntake = waterIntake.value!;
      final lastEntry = updatedWaterIntake.entries.removeLast();
      updatedWaterIntake.totalIntake -= lastEntry.amount;

      // Reassign the reactive variable
      waterIntake.value = WaterIntakeModel(
        date: updatedWaterIntake.date,
        totalIntake: updatedWaterIntake.totalIntake,
        entries: updatedWaterIntake.entries,
      );

      await _waterIntakeService.setWaterIntake(userId, updatedWaterIntake);
    }
  }

  // Set or update the water goal and its unit
  Future<void> setWaterGoal(String userId, double goal, String unit) async {
    await _waterIntakeService.updateWaterGoal(userId, goal, unit);
    waterGoal.value = goal;
    waterGoalUnit.value = unit;
  }

  // Initialize or fetch today's water intake
  Future<void> initializeTodayWaterIntake(String userId) async {
    DateTime today = DateTime.now();
    final existingWaterIntake =
        await _waterIntakeService.getWaterIntake(userId, today);

    final userController = UserController.instance.userModel.value!.waterGoal;

    waterGoal.value = userController!.amount.toDouble();
    waterGoalUnit.value = userController.unit;

    if (existingWaterIntake == null) {
      final newWaterIntake = WaterIntakeModel(
        date: today,
        totalIntake: 0.0,
        entries: [],
      );
      await _waterIntakeService.setWaterIntake(userId, newWaterIntake);
      waterIntake.value = newWaterIntake;
    } else {
      waterIntake.value = existingWaterIntake;
    }
  }
}
