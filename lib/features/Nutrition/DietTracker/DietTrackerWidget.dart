import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../Widgets/CircularProgressIndicator/CircularProgressIndicator.dart';
import 'DIetTrackerPage/DietTrackerPage.dart';

class DietTracker extends StatelessWidget {
  const DietTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => DietTrackerPage()),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularProgressWithCenterWidget(
              ProgressColor: Colors.deepOrangeAccent,
              progress: 0.75, // Set the progress value
              centerWidget: SvgPicture.asset(
                  'assets/icons/nutrition/fork-knife.svg',
                  height: 30,
                  width: 30),
              //   height: 35,)
            ),
            SizedBox(width: TSizes.spaceBtwItems),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "1500 out of 2000",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .apply(color: TColors.darkGrey),
                ),
                SizedBox(width: TSizes.spaceBtwItems / 4),
                Text("Calorie consumed Today",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .apply(color: TColors.black))
              ],
            ),
            Spacer(),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.deepOrangeAccent,
              ),
              child: Icon(Icons.add, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
