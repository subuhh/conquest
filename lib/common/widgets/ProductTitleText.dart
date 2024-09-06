import 'package:flutter/material.dart';

class ProductTitletext extends StatelessWidget {
  const ProductTitletext(
      {super.key,
      required this.title,
      this.smallSize = false,
      this.maxLines = 2,
      this.textA1ign = TextAlign.left});

  final String title;
  final bool smallSize;
  final int maxLines;
  final TextAlign? textA1ign;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: smallSize?Theme.of(context).textTheme.labelLarge : Theme.of(context).textTheme.titleSmall,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      textAlign: textA1ign,
    );
  }
}
