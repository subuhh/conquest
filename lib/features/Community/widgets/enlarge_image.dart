import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnlargeImage {
  static Future showZoomableImage(String imageUrl, BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(0),
        child: GestureDetector(
          onTap: () => Get.back(),
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: CircleAvatar(
                radius: 150,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
