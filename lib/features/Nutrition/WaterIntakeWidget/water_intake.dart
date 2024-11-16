import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      if (waterIntakeController.waterIntake.value == null) {
        return Center(child: CircularProgressIndicator());
      }

      double currentWaterIntake =
          waterIntakeController.waterIntake.value!.totalIntake;

      int waterGoal = user.userModel.value != null
          ? user.userModel.value!.waterGoal!.toInt().floor() ~/ 1000
          : 7;

      double progress = (currentWaterIntake / 1000) / waterGoal;

      return GestureDetector(
        onTap: () {
          _showWaterGoalDialog(context, waterIntakeController, user);
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
                  icon: Icon(Icons.remove,),
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
                    "${currentWaterIntake / 1000} / ${waterGoal} L",
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
                        user.userModel.value!.id, 200);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showWaterGoalDialog(BuildContext context,
      WaterIntakeController waterIntakeController, UserController user) {
    final TextEditingController goalController = TextEditingController(
      text: "${(user.userModel.value?.waterGoal ?? 2000) / 1000}", // Default in liters
    );

    String selectedUnit = "L";
    final units = ["ml", "L", "oz"];

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
                      children: [Icon(
                        Icons.local_drink,
                        color: Colors.blueAccent,
                        size: 50,
                      ),],
                    ),
                  ),
                  SizedBox(height: TSizes.spaceBtwItems,),
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: EdgeInsets.all(12)),
              onPressed: () {
                double enteredGoal = double.tryParse(goalController.text) ?? 0;

                // Convert input to liters for validation
                if (selectedUnit == "ml") {
                  enteredGoal /= 1000; // Convert milliliters to liters
                } else if (selectedUnit == "oz") {
                  enteredGoal *= 0.0295735; // Convert ounces to liters
                }

                // Validate the goal
                if (enteredGoal < 2 || enteredGoal > 5) {
                  Get.snackbar(
                    "Invalid Goal",
                    "Please enter a value between 2L and 5L.",
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                  return;
                }

                // Convert goal back to milliliters before saving
                int newGoal = (enteredGoal * 1000).toInt();
                //user.updateWaterGoal(newGoal);
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
  }
