import 'package:flutter/material.dart';

class ImageLoading {
  static Widget errorImage() {
    return Container(
      height: 165,
      width: double.infinity,
      color: Colors.grey[200],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            size: 50,
            color: Colors.grey,
          ),
          SizedBox(height: 10),
          Text(
            "Image not available",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}