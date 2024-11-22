import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/Controllers/Workout_Controller/workout_exercise_db_controller.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ExerciseController exerciseController = Get.put(ExerciseController());
    return Scaffold(
      appBar: AppBar(title: Text('Exercises')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              exerciseController.loadExercisesByBodyPart('chest');
            },
            child: Text('Load All Exercises'),
          ),
          Obx(() {
            if (exerciseController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            return Expanded(
              child: ListView.builder(
                itemCount: exerciseController.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exerciseController.exercises[index];
                  return ListTile(
                    title: Row(
                      children: [
                        Image.network(
                          exercise['gifUrl'],
                          height: 100,
                          width: 100,
                        ),
                        Expanded(child: Text(exercise['name'])),
                      ],
                    ),
                    subtitle: Text(exercise['bodyPart']),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
