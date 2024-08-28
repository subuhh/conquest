import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../features/utils/constants/colors.dart';

class CustomListTileGroup extends StatelessWidget {
  final String? header;
  final List<ListTile> tiles; // List of ListTile widgets

  const CustomListTileGroup({
    Key? key,
    this.header,
    required this.tiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        color: Colors.grey[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (header != null)
              Container(
                padding: const EdgeInsets.only(
                    top: 14.0, bottom: 10, left: 16, right: 16.0),
                decoration:  BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  color: Colors.grey[50],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      height: 20,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      header!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                    .map((tile) => Theme(
                  // Apply this theme to each ListTile
                  data: Theme.of(context).copyWith(
                    dividerColor:
                    Colors.transparent, // Remove default divider
                  ),
                  child: ListTile(
                    // tileColor: whiteColor,
                    tileColor: TColors.primaryBackground,
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
                    // ... (rest of your ListTile code)'
                  ),
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

ListTile menuListTile(
    String title, Function() onTap, String imgPath, BuildContext context,
    {bool isTrailing = true}) {
  return ListTile(
    tileColor: Colors.grey,
    title: Text(
      title,
      style: Theme.of(context).textTheme.bodyMedium,
    ),
    onTap: onTap,
    leading: CircleAvatar(
      radius: 17,
      backgroundColor: Colors.grey.withOpacity(0.2),
      child: SvgPicture.asset(
        imgPath,
        width: 20,
        height: 20,
        colorFilter:
        ColorFilter.mode(Colors.red.withOpacity(0.7), BlendMode.srcIn),
      ),
    ),
    trailing: isTrailing ? const Icon(Icons.arrow_forward_ios,color: Colors.grey,) : null,
  );
}
