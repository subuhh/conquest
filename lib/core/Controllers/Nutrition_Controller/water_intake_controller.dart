import 'package:conquest/core/services/auth_service.dart';
import 'package:get/get.dart';
import '../../model/Nutrition/water_intake_model.dart';
import '../../services/nutrition/water_intake_service.dart';

class WaterIntakeController extends GetxController {
  final WaterIntakeService _waterIntakeService = WaterIntakeService();

  Rx<WaterIntakeModel?> waterIntake = Rx<WaterIntakeModel?>(null);
  RxBool isLoading = false.obs;

  void onInit() {
    super.onInit();
    initializeTodayWaterIntake(AuthService.instance.currentUser!.uid);
  }

  // Fetch water intake data for a specific user and date
  Future<void> fetchWaterIntake(String userId, DateTime date) async {
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

  // Add a water entry to the water intake
  Future<void> addWaterEntry(String userId, double amount) async {
    if (waterIntake.value != null) {
      final updatedWaterIntake = waterIntake.value!;
      updatedWaterIntake.entries
          .add(WaterEntry(time: DateTime.now(), amount: amount));
      updatedWaterIntake.totalIntake += amount;

      await _waterIntakeService.setWaterIntake(userId, updatedWaterIntake);
      waterIntake.value = updatedWaterIntake; // Update the state
    }
  }

  Future<void> removeWaterEntry(String userId) async {
    if (waterIntake.value != null && waterIntake.value!.entries.isNotEmpty) {
      // Get the current water intake data
      final updatedWaterIntake = waterIntake.value!;

      // Get the last entry
      final lastEntry = updatedWaterIntake.entries.last;

      // Remove the last entry from the list
      updatedWaterIntake.entries.removeLast();

      // Subtract the amount of the last entry from total intake
      updatedWaterIntake.totalIntake -= lastEntry.amount;

      // Save the updated water intake
      await _waterIntakeService.setWaterIntake(userId, updatedWaterIntake);

      // Update the state with the new data
      waterIntake.value = updatedWaterIntake;
    }
  }

  // Initialize or fetch today's water intake
  Future<void> initializeTodayWaterIntake(String userId) async {
    DateTime today = DateTime.now();
    // Fetch today's water intake or create a new one if it doesn't exist
    final existingWaterIntake =
        await _waterIntakeService.getWaterIntake(userId, today);

    if (existingWaterIntake == null) {
      // If no water intake for today exists, create a new record
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
