import 'package:conquest/core/Controllers/Workout_Controller/workout_controller.dart';
import 'package:conquest/core/Controllers/Workout_Controller/workout_exercise_db_controller.dart';
import 'package:conquest/core/model/Workout/workout_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/sizes.dart';
import '../ExerciseDemo/ExerciseDemoPage.dart';
import '../WorkoutPlans/MostPopularWorouts/MostPopulatWorkouts.dart';
import 'WIdgets/BodyPartWidget.dart';
import 'WIdgets/ExerciseList.dart';
import 'WIdgets/WorkoutImageWithDetails.dart';

class WorkoutPlanPage extends StatefulWidget {
  final WorkoutDetail? workout;
  final bool wantButton;
  final WorkoutDay? workoutDay;
  const WorkoutPlanPage(
      {super.key, this.workout, this.wantButton = true, this.workoutDay});

  @override
  State<WorkoutPlanPage> createState() => _WorkoutPlanPageState();
}

class _WorkoutPlanPageState extends State<WorkoutPlanPage> {
  final exerciseController = ExerciseController.instance;
  final workoutController = WorkoutController.instance;

  void initState() {
    super.initState();
    if (widget.workout != null) {
      exerciseController.loadExercisesByBodyPart(widget.workout!.exerciseName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.workout != null
                  ? WorkoutImageWithDetails(workout: widget.workout!)
                  : WorkoutImageWithDetails(workoutDay: widget.workoutDay),
              SizedBox(height: TSizes.spaceBtwSections / 2),
              widget.workout != null
                  ? BodyPartWidget(workout: widget.workout!)
                  : BodyPartWidget(
                      workoutDay: widget.workoutDay,
                    ),
              SizedBox(height: TSizes.spaceBtwSections / 2),
              if (widget.workout != null) ...[
                ExerciseList(),
                SizedBox(height: TSizes.spaceBtwSections),
              ] else ...[
                ExerciseList(workoutDay: widget.workoutDay),
              ]
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.wantButton
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => ExerciseDemoPage());
                },
                child: Text("Start"),
              ),
            )
          : null,
    );
  }
}
