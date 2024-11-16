import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/Controllers/user_controller.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../Widgets/CircularProgressIndicator/CircularProgressIndicator.dart';

class TrackedDietWidget extends StatelessWidget {
  const TrackedDietWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance.userModel.value;

    return Card(
      color: Colors.white,
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(TSizes.spaceBtwItems),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              child: CircularProgressWithCenterWidget(
                ProgressColor: Colors.deepOrangeAccent,
                progress: 0,
                centerWidget: SvgPicture.asset(
                  'assets/icons/nutrition/fork-knife.svg',
                  height: 35,
                ),
              ),
            ),
            //SizedBox(width: TSizes.spaceBtwItems,),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "0 out of ${userController!.calorieGoal!.ceil()}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .apply(color: TColors.darkGrey),
                ),
                SizedBox(
                  width: TSizes.spaceBtwItems / 4,
                ),
                Text(
                  "Calories Eaten",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .apply(color: TColors.black),
                )
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
