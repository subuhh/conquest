import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../core/Controllers/Form_Controller/FormController.dart';

class HeightPickerScreen extends StatefulWidget {
  const HeightPickerScreen({Key? key}) : super(key: key);

  @override
  _HeightPickerScreenState createState() => _HeightPickerScreenState();
}

class _HeightPickerScreenState extends State<HeightPickerScreen> {
  // Default selected values for feet and inches

  final controller = FormController.instance;

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
              child: Obx(() => CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                        initialItem: controller.selectedFeet.value - 3),
                    itemExtent: 40.0,
                    onSelectedItemChanged: (int index) {
                      controller.selectedFeet.value = index + 3;
                    },
                    children: List<Widget>.generate(6, (int index) {
                      return Center(
                        child: Text(
                          '${index + 3} ft',
                          style: TextStyle(fontSize: 24),
                        ),
                      );
                    }),
                  )),
            ),
            // Inches picker
            Container(
              width: 100,
              height: 200,
              child: Obx(() => CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                        initialItem: controller.selectedInches.value),
                    itemExtent: 40.0,
                    onSelectedItemChanged: (int index) {
                      controller.selectedInches.value = index;
                    },
                    children: List<Widget>.generate(12, (int index) {
                      return Center(
                        child: Text(
                          '$index in',
                          style: TextStyle(fontSize: 24),
                        ),
                      );
                    }),
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
