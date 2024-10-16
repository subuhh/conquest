import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../Widgets/CircularProgressIndicator/CircularProgressIndicator.dart';

class TrackedDietWidget extends StatelessWidget {
  const TrackedDietWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
         // border: Border.all(color: Colors.grey)
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            child: CircularProgressWithCenterWidget(
              ProgressColor: Colors.deepOrangeAccent,
              progress: 0.75, centerWidget: Container(), // Set the progress value
              // centerWidget: SvgPicture.asset('assets/Icons/dinner.svg',
              //   height: 35,)
            ),
          ),
          //SizedBox(width: TSizes.spaceBtwItems,),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text("1500 out of 2000",style: Theme.of(context).textTheme.titleMedium!.apply(color: TColors.darkGrey),),
              SizedBox(width: TSizes.spaceBtwItems/4,),
              Text("Calories Eaten",style: Theme.of(context).textTheme.titleSmall!.apply(color: TColors.black))

            ],
          ),
          Spacer(),

          




        ],
      ),

    );
  }
}
