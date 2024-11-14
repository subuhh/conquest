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
    // Access WaterIntakeController
    final waterIntakeController = Get.put(WaterIntakeController());
    final user = UserController.instance;

    return Obx(() {
      // Ensure data is fetched before rendering
      if (waterIntakeController.waterIntake.value == null) {
        return Center(child: CircularProgressIndicator());
      }

      // Fetch current intake and water goal from the controller
      double currentWaterIntake =
          waterIntakeController.waterIntake.value!.totalIntake;

      int waterGoal = user.userModel.value != null
          ? user.userModel.value!.waterGoal!.toInt().floor() ~/ 1000
          : 7;

      double progress = (currentWaterIntake / 1000) / waterGoal;

      return GestureDetector(
        onTap: () {},
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
              Spacer(),
              Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.blueAccent,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, color: Colors.white),
                      onPressed: () {
                        // Add water intake
                        waterIntakeController
                            .removeWaterEntry(user.userModel.value!.id);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        // Add water intake
                        waterIntakeController.addWaterEntry(
                            user.userModel.value!.id, 200);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
