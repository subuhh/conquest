import 'package:conquest/core/Controllers/Workout_Controller/workout_exercise_db_controller.dart';
import 'package:conquest/core/services/workout_service/workout_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreWorkout extends StatelessWidget {
  const StoreWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    final exerciseController = Get.put(ExerciseController());
    // final isLoading = false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => exerciseController.loadExercisesByName('burpee'),
              child: Text('load'),
            ),
            const SizedBox(height: 10),
            Obx(
              () {
                if (exerciseController.isLoading.value) {
                  return CircularProgressIndicator();
                }

                if (exerciseController.exercises.isEmpty) {
                  return const Center(child: Text("No exercises available"));
                }

                return ListView.builder(
                  shrinkWrap: true, // To allow scrolling within the column
                  itemCount: exerciseController.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exerciseController.exercises[index];
                    return ListTile(
                      title: Text(exercise['name']),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void uploadWorkoutData() {
    List<Map<String, dynamic>> workoutPlans = [
      {
        "plan_name": "Strength Training Plan",
        "days": [
          {
            "day": "Day 1",
            "target": "Chest & Triceps",
            "exercises": [
              {
                "name": "Bench Press",
                "sets": 4,
                "reps": "8-10",
                "equipment": "Barbell"
              },
              {
                "name": "Incline Dumbbell Press",
                "sets": 3,
                "reps": "10-12",
                "equipment": "Dumbbell"
              },
              {
                "name": "Tricep Dips",
                "sets": 3,
                "reps": "10-12",
                "equipment": "Bodyweight"
              }
            ],
            "total_time": 60,
            "total_calories": 300,
            "total_exercises": 3
          },
          {
            "day": "Day 2",
            "target": "Back & Biceps",
            "exercises": [
              {
                "name": "Pull-ups",
                "sets": 4,
                "reps": "8-10",
                "equipment": "Bodyweight"
              },
              {
                "name": "Barbell Rows",
                "sets": 3,
                "reps": "10-12",
                "equipment": "Barbell"
              },
              {
                "name": "Bicep Curls",
                "sets": 3,
                "reps": "12-15",
                "equipment": "Dumbbell"
              }
            ],
            "total_time": 60,
            "total_calories": 320,
            "total_exercises": 3
          },
          {
            "day": "Day 3",
            "target": "Legs",
            "exercises": [
              {
                "name": "Squats",
                "sets": 4,
                "reps": "10-12",
                "equipment": "Barbell"
              },
              {
                "name": "Lunges",
                "sets": 3,
                "reps": "12 each leg",
                "equipment": "Bodyweight/Dumbbell"
              },
              {
                "name": "Calf Raises",
                "sets": 3,
                "reps": "15-20",
                "equipment": "Bodyweight"
              }
            ],
            "total_time": 60,
            "total_calories": 350,
            "total_exercises": 3
          },
          {
            "day": "Day 4",
            "target": "Shoulders",
            "exercises": [
              {
                "name": "Overhead Press",
                "sets": 4,
                "reps": "8-10",
                "equipment": "Barbell"
              },
              {
                "name": "Lateral Raises",
                "sets": 3,
                "reps": "12-15",
                "equipment": "Dumbbell"
              },
              {
                "name": "Face Pulls",
                "sets": 3,
                "reps": "10-12",
                "equipment": "Cable"
              }
            ],
            "total_time": 60,
            "total_calories": 310,
            "total_exercises": 3
          },
          {
            "day": "Day 5",
            "target": "Full Body",
            "exercises": [
              {
                "name": "Deadlifts",
                "sets": 4,
                "reps": "8-10",
                "equipment": "Barbell"
              },
              {
                "name": "Pull-ups",
                "sets": 3,
                "reps": "8-10",
                "equipment": "Bodyweight"
              },
              {
                "name": "Push-ups",
                "sets": 3,
                "reps": "10-15",
                "equipment": "Bodyweight"
              }
            ],
            "total_time": 60,
            "total_calories": 370,
            "total_exercises": 3
          },
          {
            "day": "Day 6",
            "target": "Active Recovery",
            "exercises": [
              {
                "name": "Yoga Flow",
                "duration": "20 minutes",
                "equipment": "Mat"
              },
              {
                "name": "Foam Rolling",
                "duration": "15 minutes",
                "equipment": "Foam Roller"
              },
              {
                "name": "Light Cardio",
                "duration": "20 minutes",
                "equipment": "Treadmill or Outdoor"
              }
            ],
            "total_time": 55,
            "total_calories": 200,
            "total_exercises": 3
          }
        ],
        "total_time": 355,
        "total_calories": 1850,
        "total_exercises": 18
      },
      {
        "plan_name": "Weight Loss Plan",
        "days": [
          {
            "day": "Day 1",
            "target": "HIIT Cardio",
            "exercises": [
              {
                "name": "Burpees",
                "sets": 4,
                "duration": "30 seconds on, 15 seconds off",
                "equipment": "Bodyweight"
              },
              {
                "name": "Mountain Climbers",
                "sets": 4,
                "duration": "30 seconds on, 15 seconds off",
                "equipment": "Bodyweight"
              },
              {
                "name": "Jump Squats",
                "sets": 4,
                "duration": "30 seconds on, 15 seconds off",
                "equipment": "Bodyweight"
              }
            ],
            "total_time": 25,
            "total_calories": 300,
            "total_exercises": 3
          },
          {
            "day": "Day 2",
            "target": "Lower Body Strength",
            "exercises": [
              {
                "name": "Step-ups",
                "sets": 3,
                "reps": "10 each leg",
                "equipment": "Dumbbell"
              },
              {
                "name": "Bulgarian Split Squats",
                "sets": 3,
                "reps": "10-12 each leg",
                "equipment": "Dumbbell"
              },
              {
                "name": "Lateral Lunges",
                "sets": 3,
                "reps": "12 each side",
                "equipment": "Bodyweight"
              }
            ],
            "total_time": 35,
            "total_calories": 250,
            "total_exercises": 3
          },
          {
            "day": "Day 3",
            "target": "Upper Body & Core",
            "exercises": [
              {
                "name": "Push-ups",
                "sets": 3,
                "reps": "10-12",
                "equipment": "Bodyweight"
              },
              {
                "name": "Plank to Shoulder Tap",
                "sets": 3,
                "duration": "30 seconds",
                "equipment": "Bodyweight"
              },
              {
                "name": "Russian Twists",
                "sets": 3,
                "reps": "15 each side",
                "equipment": "Bodyweight"
              }
            ],
            "total_time": 30,
            "total_calories": 200,
            "total_exercises": 3
          },
          {
            "day": "Day 4",
            "target": "Full Body HIIT",
            "exercises": [
              {
                "name": "Jumping Jacks",
                "sets": 4,
                "duration": "40 seconds on, 20 seconds off",
                "equipment": "Bodyweight"
              },
              {
                "name": "High Knees",
                "sets": 4,
                "duration": "40 seconds on, 20 seconds off",
                "equipment": "Bodyweight"
              },
              {
                "name": "Skater Jumps",
                "sets": 4,
                "duration": "40 seconds on, 20 seconds off",
                "equipment": "Bodyweight"
              }
            ],
            "total_time": 30,
            "total_calories": 300,
            "total_exercises": 3
          },
          {
            "day": "Day 5",
            "target": "Core Strength",
            "exercises": [
              {
                "name": "Bicycle Crunches",
                "sets": 3,
                "reps": "20 each side",
                "equipment": "Bodyweight"
              },
              {
                "name": "Plank with Arm Reach",
                "sets": 3,
                "duration": "30 seconds",
                "equipment": "Bodyweight"
              },
              {
                "name": "Leg Raises",
                "sets": 3,
                "reps": "12-15",
                "equipment": "Bodyweight"
              }
            ],
            "total_time": 25,
            "total_calories": 180,
            "total_exercises": 3
          },
          {
            "day": "Day 6",
            "target": "Active Recovery",
            "exercises": [
              {
                "name": "Yoga Sun Salutations",
                "sets": 3,
                "duration": "5 minutes",
                "equipment": "Mat"
              },
              {
                "name": "Foam Rolling",
                "duration": "10 minutes",
                "equipment": "Foam Roller"
              },
              {
                "name": "Walking or Light Jogging",
                "duration": "20 minutes",
                "equipment": "Outdoor or Treadmill"
              }
            ],
            "total_time": 35,
            "total_calories": 150,
            "total_exercises": 3
          }
        ],
        "total_time": 180,
        "total_calories": 1380,
        "total_exercises": 18
      },
      {
        "plan_name": "Cardio Plan",
        "days": [
          {
            "day": "Day 1",
            "target": "Endurance Training",
            "exercises": [
              {
                "name": "Running",
                "duration": "30 minutes",
                "equipment": "Treadmill/Outdoor"
              },
              {
                "name": "Jump Rope",
                "duration": "10 minutes",
                "equipment": "Jump Rope"
              },
              {
                "name": "Cycling",
                "duration": "20 minutes",
                "equipment": "Stationary Bike/Outdoor"
              }
            ],
            "total_time": 60,
            "total_calories": 480,
            "total_exercises": 3
          },
          {
            "day": "Day 2",
            "target": "HIIT",
            "exercises": [
              {
                "name": "Burpees",
                "sets": 3,
                "reps": "15-20",
                "equipment": "Bodyweight"
              },
              {
                "name": "High Knees",
                "sets": 3,
                "duration": "1 minute",
                "equipment": "Bodyweight"
              },
              {
                "name": "Mountain Climbers",
                "sets": 3,
                "duration": "1 minute",
                "equipment": "Bodyweight"
              }
            ],
            "total_time": 30,
            "total_calories": 240,
            "total_exercises": 3
          },
          {
            "day": "Day 3",
            "target": "Steady State Cardio",
            "exercises": [
              {
                "name": "Rowing",
                "duration": "30 minutes",
                "equipment": "Rowing Machine"
              },
              {
                "name": "Elliptical",
                "duration": "30 minutes",
                "equipment": "Elliptical Machine"
              },
              {
                "name": "Swimming",
                "duration": "30 minutes",
                "equipment": "Pool"
              }
            ],
            "total_time": 90,
            "total_calories": 720,
            "total_exercises": 3
          },
          {
            "day": "Day 4",
            "target": "Interval Training",
            "exercises": [
              {
                "name": "Sprint Intervals",
                "sets": 8,
                "duration": "30 seconds sprint, 1 minute rest",
                "equipment": "Treadmill/Outdoor"
              },
              {
                "name": "Bike Intervals",
                "sets": 8,
                "duration": "30 seconds sprint, 1 minute rest",
                "equipment": "Stationary Bike/Outdoor"
              },
              {
                "name": "Rowing Intervals",
                "sets": 8,
                "duration": "30 seconds sprint, 1 minute rest",
                "equipment": "Rowing Machine"
              }
            ],
            "total_time": 48,
            "total_calories": 384,
            "total_exercises": 3
          },
          {
            "day": "Day 5",
            "target": "Endurance Training",
            "exercises": [
              {
                "name": "Running",
                "duration": "45 minutes",
                "equipment": "Treadmill/Outdoor"
              },
              {
                "name": "Cycling",
                "duration": "45 minutes",
                "equipment": "Stationary Bike/Outdoor"
              },
              {
                "name": "Swimming",
                "duration": "45 minutes",
                "equipment": "Pool"
              }
            ],
            "total_time": 135,
            "total_calories": 1080,
            "total_exercises": 3
          },
          {
            "day": "Day 6",
            "target": "Recovery",
            "exercises": [
              {"name": "Yoga", "duration": "30 minutes", "equipment": "Mat"},
              {
                "name": "Stretching",
                "duration": "20 minutes",
                "equipment": "Bodyweight"
              },
              {
                "name": "Foam Rolling",
                "duration": "15 minutes",
                "equipment": "Foam Roller"
              }
            ],
            "total_time": 65,
            "total_calories": 260,
            "total_exercises": 3
          }
        ],
        "total_time": 428,
        "total_calories": 3164,
        "total_exercises": 18
      },
      {
        "plan_name": "Flexibility & Mobility Plan",
        "days": [
          {
            "day": "Day 1",
            "target": "Full Body Flexibility",
            "exercises": [
              {
                "name": "Dynamic Stretching",
                "duration": "10 minutes",
                "equipment": "Bodyweight"
              },
              {
                "name": "Static Stretching",
                "duration": "20 minutes",
                "equipment": "Bodyweight"
              },
              {
                "name": "Foam Rolling",
                "duration": "10 minutes",
                "equipment": "Foam Roller"
              }
            ],
            "total_time": 40,
            "total_calories": 160,
            "total_exercises": 3
          },
          {
            "day": "Day 2",
            "target": "Upper Body Mobility",
            "exercises": [
              {
                "name": "Shoulder Circles",
                "sets": 3,
                "reps": "10 each direction",
                "equipment": "Bodyweight"
              },
              {
                "name": "Arm Swings",
                "sets": 3,
                "reps": "10 each direction",
                "equipment": "Bodyweight"
              },
              {
                "name": "Thoracic Spine Rotation",
                "sets": 3,
                "reps": "10 each side",
                "equipment": "Bodyweight"
              }
            ],
            "total_time": 30,
            "total_calories": 120,
            "total_exercises": 3
          },
          {
            "day": "Day 3",
            "target": "Lower Body Mobility",
            "exercises": [
              {
                "name": "Hip Circles",
                "sets": 3,
                "reps": "10 each direction",
                "equipment": "Bodyweight"
              },
              {
                "name": "Ankle Mobility Drills",
                "sets": 3,
                "duration": "5 minutes",
                "equipment": "Bodyweight"
              },
              {
                "name": "Hamstring Stretch",
                "sets": 3,
                "duration": "1 minute each side",
                "equipment": "Bodyweight"
              }
            ],
            "total_time": 40,
            "total_calories": 160,
            "total_exercises": 3
          },
          {
            "day": "Day 4",
            "target": "Yoga Flow",
            "exercises": [
              {
                "name": "Sun Salutations",
                "sets": 5,
                "duration": "5 minutes",
                "equipment": "Mat"
              },
              {
                "name": "Warrior Poses",
                "sets": 3,
                "duration": "1 minute each pose",
                "equipment": "Mat"
              },
              {
                "name": "Child's Pose",
                "sets": 3,
                "duration": "2 minutes",
                "equipment": "Mat"
              }
            ],
            "total_time": 40,
            "total_calories": 160,
            "total_exercises": 3
          },
          {
            "day": "Day 5",
            "target": "Active Stretching",
            "exercises": [
              {
                "name": "Leg Swings",
                "sets": 3,
                "reps": "10 each leg",
                "equipment": "Bodyweight"
              },
              {
                "name": "Hip Flexor Stretch",
                "sets": 3,
                "duration": "1 minute each side",
                "equipment": "Bodyweight"
              },
              {
                "name": "Cat-Cow Stretch",
                "sets": 3,
                "duration": "1 minute",
                "equipment": "Bodyweight"
              }
            ],
            "total_time": 30,
            "total_calories": 120,
            "total_exercises": 3
          },
          {
            "day": "Day 6",
            "target": "Recovery & Relaxation",
            "exercises": [
              {
                "name": "Meditation",
                "duration": "10 minutes",
                "equipment": "None"
              },
              {
                "name": "Deep Breathing",
                "duration": "10 minutes",
                "equipment": "None"
              },
              {
                "name": "Light Stretching",
                "duration": "15 minutes",
                "equipment": "Bodyweight"
              }
            ],
            "total_time": 35,
            "total_calories": 140,
            "total_exercises": 3
          }
        ],
        "total_time": 215,
        "total_calories": 860,
        "total_exercises": 18
      }
    ];

    WorkoutService().storeWorkoutPlans(workoutPlans);
    // log('Workout data stored successfully');
  }
}
