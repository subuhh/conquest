import 'package:flutter/material.dart';

import '../../../core/Controllers/Form_Controller/FormController.dart';

class AgeQuestion extends StatelessWidget {
  const AgeQuestion({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = FormController.instance;

    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter Your Age',
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),

          ),
          onChanged: (value) {
            controller.selectedAge.value = int.parse(value);
          },
        ),
      ],
    );
  }
}
