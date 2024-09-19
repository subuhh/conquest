import 'package:conquest/utils/theme/customthemes/textThemes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Iconbuttonwithlabel extends StatelessWidget {
  const Iconbuttonwithlabel(
      {super.key, required this.labelText, required this.imagePath});
  final String labelText;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(imagePath, height: 35),
        ),
        Text(
          labelText,
          style: TTextTheme.lightTextTheme.labelLarge,
        )
      ],
    );
  }
}
