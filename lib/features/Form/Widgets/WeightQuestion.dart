import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/Controllers/Form_Controller/FormControllr.dart';
import '../../../utils/constants/sizes.dart';

class WeightPickerScreen extends StatefulWidget {
  const WeightPickerScreen({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final FormController controller;
  @override
  _WeightPickerScreenState createState() => _WeightPickerScreenState();
}

class _WeightPickerScreenState extends State<WeightPickerScreen> {
  // Default selected values
  int selectedInteger = 60;
  int selectedFraction = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Integer picker
            Container(
              width: 100,
              height: 200,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                    initialItem: selectedInteger - 50), // Starts at 60 kg
                itemExtent: 40.0,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    selectedInteger = index + 50;
                  });
                },
                children: List<Widget>.generate(100, (int index) {
                  return Center(
                    child: Text(
                      (index + 50).toString(),
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }),
              ),
            ),
            // Fraction picker
            Container(
              width: 100,
              height: 200,
              child: CupertinoPicker(
                scrollController:
                    FixedExtentScrollController(initialItem: selectedFraction),
                itemExtent: 40.0,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    selectedFraction = index;
                  });
                },
                children: List<Widget>.generate(10, (int index) {
                  return Center(
                    child: Text(
                      '.$index kg',
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
        SizedBox(
          height: TSizes.spaceBtwSections,
        ),
        SizedBox(
            width: 300,
            child: ElevatedButton(
                onPressed: () {
                  widget.controller.nextQuestion();
                },
                child: Text('Next')))
      ],
    );
  }
}
