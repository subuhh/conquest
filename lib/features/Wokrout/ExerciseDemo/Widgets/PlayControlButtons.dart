import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';


class PlayControlButtons extends StatefulWidget {
  @override
  _PlayControlButtonsState createState() => _PlayControlButtonsState();
}

class _PlayControlButtonsState extends State<PlayControlButtons> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous Button
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          child: IconButton(
            icon: Icon(Icons.skip_previous, color: Colors.black54),
            onPressed: () {
              // Add your previous button functionality here
            },
          ),
        ),
        SizedBox(width: 20),

        // Play/Pause Button
        GestureDetector(
          onTap: () {
            setState(() {
              isPlaying = !isPlaying;
            });
          },
          child: Container(
            width: 200,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [TColors.primary,Colors.redAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        SizedBox(width: 20),

        // Next Button
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white54,
            border: Border.all(color: Colors.white, width: 0),
          ),
          child: IconButton(
            icon: Icon(Icons.skip_next, color: Colors.black,size: 40,),
            onPressed: () {

            },
          ),
        ),
      ],
    );
  }
}