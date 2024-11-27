class WorkoutPlan {
  final String planName;
  final List<WorkoutDay> days;
  final int totalTime; // Total workout time for the plan
  final int totalCalories; // Total calories burned for the plan
  final int totalExercises; // Total exercises in the plan

  WorkoutPlan({
    required this.planName,
    required this.days,
    required this.totalTime,
    required this.totalCalories,
    required this.totalExercises,
  });

  // Empty constructor (default values)
  WorkoutPlan.empty()
      : planName = '',
        days = [],
        totalTime = 0,
        totalCalories = 0,
        totalExercises = 0;

  // Convert WorkoutPlan to JSON
  Map<String, dynamic> toJson() => {
        'plan_name': planName,
        'days': days.map((day) => day.toJson()).toList(),
        'total_time': totalTime,
        'total_calories': totalCalories,
        'total_exercises': totalExercises,
      };

  // Create WorkoutPlan from JSON
  factory WorkoutPlan.fromJson(Map<String, dynamic> json) => WorkoutPlan(
        planName: json['plan_name'],
        days: (json['days'] as List)
            .map((dayJson) => WorkoutDay.fromJson(dayJson))
            .toList(),
        totalTime: json['total_time'],
        totalCalories: json['total_calories'],
        totalExercises: json['total_exercises'],
      );
}

class WorkoutDay {
  final String day;
  final String target;
  final List<Exercise> exercises;
  final int totalTime; // Total time for the day
  final int totalCalories; // Total calories burned for the day
  final int totalExercises; // Total number of exercises for the day

  WorkoutDay({
    required this.day,
    required this.target,
    required this.exercises,
    required this.totalTime,
    required this.totalCalories,
    required this.totalExercises,
  });

  // Empty constructor (default values)
  WorkoutDay.empty()
      : day = '',
        target = '',
        exercises = [],
        totalTime = 0,
        totalCalories = 0,
        totalExercises = 0;

  // Convert WorkoutDay to JSON
  Map<String, dynamic> toJson() => {
        'day': day,
        'target': target,
        'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
        'total_time': totalTime,
        'total_calories': totalCalories,
        'total_exercises': totalExercises,
      };

  // Create WorkoutDay from JSON
  factory WorkoutDay.fromJson(Map<String, dynamic> json) => WorkoutDay(
        day: json['day'],
        target: json['target'],
        exercises: (json['exercises'] as List)
            .map((exerciseJson) => Exercise.fromJson(exerciseJson))
            .toList(),
        totalTime: json['total_time'],
        totalCalories: json['total_calories'],
        totalExercises: json['total_exercises'],
      );
}

class Exercise {
  final String name;
  final int? sets;
  final String? reps;
  final String? duration; // Duration as string, e.g., "10 mins"
  final String equipment;

  Exercise({
    required this.name,
    this.sets,
    this.reps,
    this.duration,
    required this.equipment,
  });

  // Empty constructor (default values)
  Exercise.empty()
      : name = '',
        sets = 0,
        reps = '',
        duration = '',
        equipment = '';

  // Convert Exercise to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'sets': sets,
        'reps': reps,
        'duration': duration,
        'equipment': equipment,
      };

  // Create Exercise from JSON
  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        name: json['name'],
        sets: json['sets'],
        reps: json['reps'],
        duration: json['duration'],
        equipment: json['equipment'],
      );
}
