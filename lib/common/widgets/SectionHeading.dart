import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

class Sectionheading extends StatelessWidget {
  final Color? textColor;
  final bool showActionButton;
  final String title;
  final bool isPadding;
  final bool isHeader;
  final Widget widgetActionButton;

  const Sectionheading({
    super.key,
    this.textColor,
    this.isPadding = false,
    this.showActionButton = true,
    required this.title,
    this.isHeader = false,
    this.widgetActionButton = const SizedBox(),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isPadding
          ? const EdgeInsets.only(
              left: TSizes.defaultSpace,
              right: TSizes.defaultSpace,
            )
          : EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isHeader)
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: 20,
                    color: TColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .apply(color: textColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          if (!isHeader)
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .apply(color: textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          if (showActionButton) widgetActionButton
        ],
      ),
    );
  }
}
