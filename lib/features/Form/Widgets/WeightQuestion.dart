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
  String selectedUnit = 'Kg'; // Kg or Lbs

  // Conversion methods
  double get weightInKg => selectedInteger + selectedFraction / 10;
  double get weightInLbs => weightInKg * 2.20462;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dropdown for selecting between Kg and Lbs
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select Unit: ',style: Theme.of(context).textTheme.titleSmall,),
            DropdownButton<String>(
              value: selectedUnit,
              items: <String>['Kg', 'Lbs'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  if (newValue != null) {
                    if (newValue != selectedUnit) {
                      selectedUnit = newValue;
                      // Adjust the pickers when switching
                      if (selectedUnit == 'Lbs') {
                        // Convert the current kg value to lbs
                        double weightInLbs = weightInKg * 2.20462;
                        selectedInteger = weightInLbs.floor();
                        selectedFraction = ((weightInLbs - selectedInteger) * 10).round();
                      } else {
                        // Convert the current lbs value to kg
                        double weightInKg = weightInLbs / 2.20462;
                        selectedInteger = weightInKg.floor();
                        selectedFraction = ((weightInKg - selectedInteger) * 10).round();
                      }
                    }
                  }
                });
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Integer picker
            Container(
              width: 100,
              height: 200,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                    initialItem: selectedUnit == 'Kg' ? selectedInteger - 50 : selectedInteger - 110), // Starts at 50 kg or 110 lbs
                itemExtent: 40.0,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    if (selectedUnit == 'Kg') {
                      selectedInteger = index + 50;
                    } else {
                      selectedInteger = index + 110;
                    }
                  });
                },
                children: List<Widget>.generate(100, (int index) {
                  return Center(
                    child: Text(
                      selectedUnit == 'Kg' ? (index + 50).toString() : (index + 110).toString(),
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
                      selectedUnit == 'Kg' ? '.$index kg' : '.$index lbs',
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
