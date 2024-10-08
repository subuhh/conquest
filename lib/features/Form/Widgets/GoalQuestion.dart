import 'package:flutter/material.dart';
import '../../../core/Controllers/Form_Controller/FormController.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class GoalQuestion extends StatefulWidget {
  const GoalQuestion({super.key});

  @override
  State<GoalQuestion> createState() => _GoalQuestionState();
}

class _GoalQuestionState extends State<GoalQuestion> {

  final controller = FormController.instance;
  List<String> get _selectedGoals => controller.selectedGoals;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildGoalButton(
          context,
          label: "Lose Weight",
          subtitle: "Reduce body fat and improve fitness",
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        _buildGoalButton(
          context,
          label: "Gain Muscles",
          subtitle: "Increase muscle mass and size",
        ),
        SizedBox(height: TSizes.spaceBtwItems),
        _buildGoalButton(
          context,
          label: "Build Strength",
          subtitle: "Develop overall strength and endurance",
        ),
        SizedBox(height: TSizes.spaceBtwItems),
      ],
    );
  }

  Widget _buildGoalButton(
    BuildContext context, {
    required String label,
    required String subtitle,
  }) {
    bool isSelected = _selectedGoals.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedGoals.remove(label);
          } else {
            _selectedGoals.add(label);
          }
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected
                ? TColors.primary
                : Colors.grey, // Border color change
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12), // Less rounded border
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns subtitle left
          children: [
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .apply(fontSizeFactor: 0.5)
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4), // Space between title and subtitle
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
  }
}
