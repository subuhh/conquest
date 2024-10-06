import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/Controllers/Form_Controller/FormControllr.dart';
import '../../../utils/constants/sizes.dart';

class HeightPickerScreen extends StatefulWidget {
  const HeightPickerScreen({Key? key, required this.controller})
      : super(key: key);
  final FormController controller;

  @override
  _HeightPickerScreenState createState() => _HeightPickerScreenState();
}

class _HeightPickerScreenState extends State<HeightPickerScreen> {
  // Default selected values for feet and inches
  int selectedFeet = 5;
  int selectedInches = 7;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Feet picker
            Container(
              width: 100,
              height: 200,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                    initialItem: selectedFeet - 3), // Starts at 3 feet
                itemExtent: 40.0,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    selectedFeet = index + 3;
                  });
                },
                children: List<Widget>.generate(6, (int index) {
                  return Center(
                    child: Text(
                      '${index + 3} ft',
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }),
              ),
            ),
            // Inches picker
            Container(
              width: 100,
              height: 200,
              child: CupertinoPicker(
                scrollController:
                    FixedExtentScrollController(initialItem: selectedInches),
                itemExtent: 40.0,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    selectedInches = index;
                  });
                },
                children: List<Widget>.generate(12, (int index) {
                  return Center(
                    child: Text(
                      '$index in',
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),

      ],
    );
  }
}
