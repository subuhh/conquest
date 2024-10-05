import 'package:flutter/material.dart';

Widget buildPage({required String image, required String title, required String description,double height =250}) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: height,colorBlendMode: BlendMode.colorBurn,),
        //SizedBox(height: 20),
        Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
        SizedBox(height: 10),
        Text(description, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
      ],
    ),
  );
}