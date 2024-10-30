import 'package:conquest/features/Wokrout/ExerciseDemo/ExerciseDemoPage.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/sizes.dart';
import '../WorkoutPlans/MostPopularWorouts/MostPopulatWorkouts.dart';
import 'WIdgets/BodyPartWidget.dart';
import 'WIdgets/ExerciseList.dart';
import 'WIdgets/WorkoutImageWithDetails.dart';

class WorkoutPlanPage extends StatelessWidget {
  const WorkoutPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Exercisedemopage()));
        }, child: Text("Start")),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkoutImageWithDetails(),
                SizedBox(
                  height: TSizes.spaceBtwSections / 2,
                ),
                Bodypartwidget(),
                SizedBox(
                  height: TSizes.spaceBtwSections / 2,
                ),
                Exerciselist(),
                SizedBox(height: TSizes.spaceBtwSections,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Mostpopulatworkouts(),
                )
                // This will now be visible
              ],
            ),
          )),
    );
  }
}
