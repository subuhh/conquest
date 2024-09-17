import 'package:conquest/utils/helpers/helper_functions.dart';
import 'package:conquest/utils/theme/customthemes/textThemes.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TAnimationPage extends StatelessWidget {
  const TAnimationPage(
      {super.key,
      required this.asset,
      required this.height,
      required this.width,
      required this.titleText,
      this.onPressed,
      required this.buttonText});

  final String asset;
  final double height;
  final double width;
  final String titleText;
  final Function()? onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            SizedBox(height: THelperFunctions.screenHeight(context) * 0.18),
            Lottie.asset(
              asset,
              height: height,
              width: width,
            ),
            Text(
              titleText,
              style: TTextTheme.lightTextTheme.headlineSmall,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: THelperFunctions.screenWidth(context) * 0.6,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.black87),
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
