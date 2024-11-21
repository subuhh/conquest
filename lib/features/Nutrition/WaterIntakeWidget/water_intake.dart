import 'package:conquest/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import 'package:conquest/features/Nutrition/Widgets/CircularProgressIndicator/CircularProgressIndicator.dart';
import '../../../core/Controllers/Nutrition_Controller/water_intake_controller.dart';
import '../../../core/Controllers/user_controller.dart';

class WaterIntake extends StatelessWidget {
  const WaterIntake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final waterIntakeController = Get.put(WaterIntakeController());
    final user = UserController.instance;

    return Obx(() {
      if (waterIntakeController.isLoading.value) {
        return Center(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
            ),
          ),
        );
      }

      double waterGoal = waterIntakeController.waterGoal.value;
      String waterUnit = waterIntakeController.waterGoalUnit.value;

      double currentWaterIntake = 0.0;
      double progress = 0.0;

      if (waterIntakeController.waterIntake.value != null) {
        currentWaterIntake = waterUnit == 'ML'
            ? waterIntakeController.waterIntake.value!.totalIntake
            : waterIntakeController.waterIntake.value!.totalIntake / 1000;
        progress = currentWaterIntake / waterGoal;
      }

      return GestureDetector(
        onTap: () {
          _showWaterGoalDialog(
              context, waterIntakeController, user, waterUnit, waterGoal);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                backgroundColor: TColors.softGrey,
                child: IconButton(
                  icon: Icon(
                    Icons.remove,
                  ),
                  onPressed: () {
                    waterIntakeController
                        .removeWaterEntry(user.userModel.value!.id);
                  },
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressWithCenterWidget(
                    progress: progress,
                    ProgressColor: Colors.blueAccent,
                    centerWidget: Icon(
                      Icons.local_drink,
                      color: Colors.blueAccent,
                      size: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(width: TSizes.spaceBtwItems),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Water Intake",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .apply(color: TColors.darkGrey),
                  ),
                  SizedBox(height: TSizes.spaceBtwItems / 4),
                  Text(
                    "${currentWaterIntake} / ${removeDecimalZeroFormat(waterGoal)} $waterUnit",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .apply(color: TColors.black),
                  ),
                ],
              ),
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    waterIntakeController.addWaterEntry(
                        user.userModel.value!.id, 250);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showWaterGoalDialog(
      BuildContext context,
      WaterIntakeController waterIntakeController,
      UserController user,
      String waterUnit,
      double waterGoal) {
    final TextEditingController goalController =
        TextEditingController(text: "$waterGoal");

    String selectedUnit = waterUnit;
    final units = ["ML", "L"];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Set Daily Water Goal"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_drink,
                          color: Colors.blueAccent,
                          size: 50,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  TextField(
                    controller: goalController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Water Goal",
                      suffixText: selectedUnit,
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedUnit,
                    items: units.map((unit) {
                      return DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedUnit = value!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, padding: EdgeInsets.all(12)),
              onPressed: () async {
                double enteredGoal = double.tryParse(goalController.text) ?? 0;

                // Convert input to ml for validation
                double enteredGoalInMl =
                    selectedUnit == "L" ? enteredGoal * 1000 : enteredGoal;

                // Validate goal in ml
                if (enteredGoalInMl < 2000 || enteredGoalInMl > 5000) {
                  TLoaders.errorSnackBar(
                    title: "Invalid Goal",
                    message:
                        "Please enter a value between 2000ml (2L) and 5000ml (5L).",
                  );
                  return;
                }

                // Convert back to appropriate unit for saving
                double finalGoal =
                    selectedUnit == "L" ? enteredGoal : enteredGoalInMl;

                await waterIntakeController.setWaterGoal(
                    user.userModel.value!.id, finalGoal, selectedUnit);
                Get.back();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}

String removeDecimalZeroFormat(double n) {
  // Check if the number is a whole number
  if (n.truncateToDouble() == n) {
    return n.toStringAsFixed(0); // Return without decimal places
  } else {
    return n.toStringAsFixed(1); // Return with one decimal place
  }
}
