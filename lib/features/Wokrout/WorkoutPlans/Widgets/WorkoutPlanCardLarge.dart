import 'package:flutter/material.dart';

import '../../../../utils/constants/sizes.dart';
import '../../WorkoutTutorial/WorkoutTutorialPage.dart';

class WorkkoutPlanCardLarge extends StatelessWidget {
  const WorkkoutPlanCardLarge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: (){Navigator.push(context, MaterialPageRoute(builder: (ctx)=>WorkoutPlanPage()));},
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/icons/Workout/img.png',
                  height: 300,
                  width: 200,
                  fit: BoxFit.fitHeight,
                )),
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8)),
                    height: 25,
                    width: 50,
                    child: Center(
                        child: Text(
                          '21/21',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .apply(color: Colors.black),
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8)),
                    height: 25,
                    width: 100,
                    child: Center(
                        child: Text(
                          'Uncompleted',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .apply(color: Colors.white),
                        )),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Column(
                  children: [
                    Text(
                      "GYM Back Strengthening",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .apply(color: Colors.white, fontWeightDelta: 25),
                    ),
                    SizedBox(height: TSizes.spaceBtwItems/2,),
                    Text(
                      "23 mins / 142 kal / Intermediate",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .apply(color: Colors.white,),
                    ),
                    SizedBox(height: TSizes.spaceBtwItems/2,),

                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(5),
                          ),

                          onPressed: (){}, child: Text("Start")),
                    )


                  ],
                )),
          ],
        ),
      ),
    );
  }
}
