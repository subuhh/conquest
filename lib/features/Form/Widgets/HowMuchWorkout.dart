import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../core/Controllers/Form_Controller/FormController.dart';
import '../../../utils/constants/colors.dart';

class HowMuchWorkout extends StatefulWidget {
  const HowMuchWorkout({super.key});

  @override
  _HowMuchWorkoutState createState() => _HowMuchWorkoutState();
}

class _HowMuchWorkoutState extends State<HowMuchWorkout> {
  final controller = FormController.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        _buildOptionButton(
            "Daily", "You're dedicated to working out every single day."),
        SizedBox(height: 8),
        _buildOptionButton("Weekly",
            "You have a regular workout routine and exercise several times a week."),
        SizedBox(height: 8),
        _buildOptionButton("Occasionally",
            "You work out from time to time, but not on a consistent schedule."),
        SizedBox(height: 8),
        _buildOptionButton("Rarely",
            "You rarely find time for exercise and workouts are infrequent."),
        SizedBox(height: 8),
        _buildOptionButton("Sedentary",
            "You lead a mostly inactive lifestyle with little to no exercise."),
      ],
    );
  }

  Widget _buildOptionButton(String label, String subtitle) {
    return Obx(() {
      final isSelected = controller.selectedWorkoutFrequency.value == label;
      return GestureDetector(
        onTap: () {
          controller.selectedWorkoutFrequency.value =
              isSelected ? '' : label; // Deselect if already selected
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: isSelected
                  ? TColors.primary // Primary color for selected state
                  : Colors.grey[300]!, // Light grey for unselected state
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12), // Less rounded border
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Subtle shadow
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligns subtitle left
            children: [
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .apply(fontSizeFactor: 0.5)
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .apply(fontSizeFactor: 0.8, color: Colors.black54),
              ),
            ],
          ),
        ),
      );
    });
  }
}
