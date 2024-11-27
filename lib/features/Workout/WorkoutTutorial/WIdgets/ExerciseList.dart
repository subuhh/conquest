import 'package:cached_network_image/cached_network_image.dart';
import 'package:conquest/core/model/Workout/workout_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../core/Controllers/Workout_Controller/workout_exercise_db_controller.dart';

class ExerciseList extends StatefulWidget {
  final WorkoutDay? workoutDay;
  const ExerciseList({super.key, this.workoutDay});

  @override
  _ExerciseListState createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  bool isExpanded = false; // Track whether the list is expanded
  final ExerciseController exerciseController = Get.find();

  void initState() {
    super.initState();
    if (widget.workoutDay != null) {
      exerciseController.loadExercisesForCurrentDay(widget.workoutDay!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: TSizes.spaceBtwItems),
            VerticalDivider(thickness: 3, color: TColors.primary),
            Text(
              "Exercises",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        Obx(() {
          if (exerciseController.isLoading.value) {
            return loadingShimmer();
          }

          if (exerciseController.exercises.isEmpty ||
              exerciseController.exercises[0] == null) {
            return const Center(child: Text("No exercises available"));
          }

          int totalItems = exerciseController.exercises.length;

          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: isExpanded ? totalItems : 5,
                itemBuilder: (context, index) {
                  final exercise = exerciseController.exercises[index];

                  String formattedIndex =
                      (index + 1).toString().padLeft(2, '0');

                  if (exercise == null || exercise.isEmpty) {
                    return Center(child: Text('It is empty'));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: TSizes.spaceBtwItems),
                          Text(
                            formattedIndex,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Expanded(
                              child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: TSizes.spaceBtwItems / 2,
                                horizontal: TSizes.spaceBtwItems),
                            leading: CachedNetworkImage(
                              imageUrl: exercise['gifUrl'] ?? '',
                              height: 120,
                              width: 100,
                              fit: BoxFit.cover,
                              errorWidget: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                            ),
                            title: Text(
                              capitalizeFirstLetter(
                                  exercise['name'] ?? 'Unknown Exercise'),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            subtitle: Text(
                              capitalizeFirstLetter(
                                  exercise['target'] ?? 'Unknown Target'),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          )),
                        ],
                      ),
                    );
                  }
                },
              ),
              if (totalItems > 5)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded; // Toggle the expanded state
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isExpanded ? "Show Less" : "Show More",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .apply(color: Colors.grey),
                        ),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }

  Widget loadingShimmer() {
    return Column(
      children: List.generate(
        5,
        (index) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
                vertical: TSizes.spaceBtwItems / 2,
                horizontal: TSizes.spaceBtwItems),
            leading: Container(
              height: 120,
              width: 100,
              color: Colors.grey[300],
            ),
            title: Container(
              width: double.infinity,
              height: 20.0,
              color: Colors.grey[300],
            ),
            subtitle: Container(
              width: double.infinity,
              height: 16.0,
              color: Colors.grey[300],
              margin: EdgeInsets.only(top: 8.0),
            ),
          ),
        ),
      ),
    );
  }
}

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input; // Return the input if it's empty
  return input[0].toUpperCase() + input.substring(1);
}
