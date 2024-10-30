import 'package:flutter/material.dart';

import '../../WorkoutTutorial/WorkoutTutorialPage.dart';


class Workkoutplancardsmall extends StatelessWidget {
  const Workkoutplancardsmall({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){Navigator.push(context, MaterialPageRoute(builder: (ctx)=>WorkoutPlanPage()));},
        child: Column(

        children: [
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 180,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('assets/icons/Workout/img.png'))),



                Text("Beginer Chest Building",style: Theme.of(context).textTheme.titleMedium,textAlign: TextAlign.left,),
                Text("9 Mins / 48 kal / Beginers",style: Theme.of(context).textTheme.titleSmall!.apply(color: Colors.grey),textAlign: TextAlign.left,)



              ],
            ),
          ),


        ],
        ),
      ),
    );
  }
}
