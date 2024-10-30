import 'package:flutter/material.dart';
import '../../../../utils/constants/sizes.dart';

class Exercisecard extends StatelessWidget {
  const Exercisecard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Image.network('https://apilyfta.com/static/GymvisualPNG/14791101-Lever-Incline-Chest-Press_Chest_small.png',height: 120,width: 120,),
          SizedBox(width: TSizes.spaceBtwItems,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text("ExerCise Name",style: Theme.of(context).textTheme.headlineSmall,),
            Text("8 Reps",style: Theme.of(context).textTheme.bodyLarge,)
          ],)
        ],
      ),
    );
  }
}
