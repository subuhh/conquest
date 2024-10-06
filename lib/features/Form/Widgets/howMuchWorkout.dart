import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';


class Howmuchworkout extends StatelessWidget {
  const Howmuchworkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
            width: 300,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.white),
                onPressed: () {

                },
                child: Text(
                  "Daily",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .apply(fontSizeFactor: 0.5),
                ))),
        SizedBox(
          height: TSizes.spaceBtwItems,
        ),
        SizedBox(
            width: 300,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.white),
                onPressed: () {


                },
                child: Text(
                  "Weekly",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .apply(fontSizeFactor: 0.5),
                ))),
        SizedBox(
          height: TSizes.spaceBtwItems,
        ),
        SizedBox(
            width: 300,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.white),
                onPressed: () {


                },
                child: Text(
                  "Not regular",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .apply(fontSizeFactor: 0.5),
                ))),
        SizedBox(
          height: TSizes.spaceBtwItems,
        ),
      ],
    );
  }
}
