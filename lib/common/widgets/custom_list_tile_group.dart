import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../features/utils/constants/colors.dart';
import '../../features/utils/theme/customthemes/textThemes.dart';

class CustomListTileGroup extends StatelessWidget {
  final String? header;
  final List<ListTile> tiles; // List of ListTile widgets

  const CustomListTileGroup({
    super.key,
    this.header,
    required this.tiles,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null)
            Container(
              padding: const EdgeInsets.only(
                  top: 14.0, bottom: 10, left: 16, right: 16.0),
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
                    header!,
                    style: TTextTheme.lightTextTheme.headlineSmall,
                  ),
                ],
              ),
            ),

          // List of Tiles
          ClipRRect(
            // Apply rounded corners to the ListTile group
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
            child: Column(
              children: tiles
                  .map(
                    (tile) => Theme(
                      // Apply this theme to each ListTile
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ListTile(
                        // tileColor: whiteColor,
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          // Round the corners of individual tiles
                          borderRadius: BorderRadius.vertical(
                            bottom: tile == tiles.last
                                ? const Radius.circular(10.0)
                                : Radius
                                    .zero, // Only round bottom corners of the last tile
                          ),
                        ),
                        leading: tile.leading,
                        onTap: tile.onTap,
                        trailing: tile.trailing,
                        title: tile.title,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

ListTile menuListTile(
    String title, Function() onTap, String imgPath, BuildContext context,
    {bool isTrailing = true}) {
  return ListTile(
    tileColor: Colors.white,
    title: Text(
      title,
      style: TTextTheme.lightTextTheme.titleLarge,
    ),
    onTap: onTap,
    leading: CircleAvatar(
      radius: 18,
      backgroundColor: Colors.grey.withOpacity(0.2),
      child: SvgPicture.asset(
        imgPath,
        width: 22,
        height: 22,
        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.75), BlendMode.srcIn),
      ),
    ),
    trailing: isTrailing
        ? const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          )
        : null,
  );
}
