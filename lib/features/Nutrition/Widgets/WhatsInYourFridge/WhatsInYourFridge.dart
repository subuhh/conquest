import 'package:conquest/features/Nutrition/WhatsInYourFridge/WhatsInYourFridgePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/constants/sizes.dart';

class WhatsInYourFridge extends StatelessWidget {
  const WhatsInYourFridge({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (ctx)=>Whatsinyourfridgepage())),
      child: Container(
        height: 175,
        width: 175,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: TSizes.spaceBtwItems / 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SvgPicture.asset(
                'assets/icons/nutrition/fridge-2.svg',
                height: 75,
              ),
              Text(
                "What is inside Your Fridge?",
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
