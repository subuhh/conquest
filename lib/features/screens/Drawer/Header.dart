import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';

Widget buildLoggedInHeader(BuildContext context) {
  return Container(
    margin: const EdgeInsets.all(10.0),
    padding:
    const EdgeInsets.only(top: 24.0, left: 16, bottom: 24, right: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        // if (_userModel != null) ...[
        const CircleAvatar(
          radius: 35,
          backgroundColor: TColors.grey,
          child: Text(
            'C',
            style: TextStyle(fontSize: 32, color: Colors.white),
          ),
        ),
        // ] else ...[
        //   CircleAvatar(
        //     radius: 35,
        //     backgroundColor: TColors.primaryBackground,
        //     child: Text(
        //       'G',
        //       style: Theme.of(context).textTheme.headlineLarge,
        //     ),
        //   ),
        // ],
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hey, ConQuest',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'xyz@gmail.com',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}