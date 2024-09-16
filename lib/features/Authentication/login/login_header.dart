import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';


class loginHeader extends StatelessWidget {
  const loginHeader({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              height: 80,
              image: AssetImage('assets/logos/conquest-icon.png'),
            ),
            Image(
              height: 150,
              image: AssetImage('assets/logos/conquest-string.png'),
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwSections,),
        Text(
         'Welcome',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        // const SizedBox(
        //   height: TSizes.sm,
        // ),
        // Text(
        //   TTexts.loginSubTitle,
        //   style: Theme.of(context).textTheme.bodyMedium,
        // ),
      ],
    );
  }
}