import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildDrawerHeaderShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[200]!,
    highlightColor: Colors.grey[50]!,
    child: Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity, // Adjust width as needed
            height: 40.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 120.0,
            height: 20.0,
            color: Colors.white,
          ),
          const SizedBox(height: 4.0),
          Container(
            width: 180.0,
            height: 16.0,
            color: Colors.white,
          ),
        ],
      ),
    ),
  );
}