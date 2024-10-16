import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../utils/constants/sizes.dart';

class NewMealFromScratch extends StatelessWidget {
  const NewMealFromScratch({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      width: 175,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.spaceBtwItems/2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset('assets/icons/nutrition/newMeal.svg',height: 75,),
            Text("Create a new Meal from Scratch",style: Theme.of(context).textTheme.titleSmall,)
          ],
        ),
      ),
    );
  }
}
