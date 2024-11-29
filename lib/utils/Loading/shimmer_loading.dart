import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading {

  static Widget shimmerListView() {
    return SizedBox(
      height: 300, // Adjust this height based on the item size
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4, // Show a few shimmer items
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.475,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: buildShimmerProductCard(),
            ),
          );
        },
      ),
    );
  }

  static Widget shimmerGridView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 8, // Show a few shimmer items
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75, // Adjust the aspect ratio as needed
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: buildShimmerProductCard(),
        );
      },
    );
  }

  static Widget buildShimmerProductCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 15,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  // Shimmer for the "Add to Cart" button
                  height: 35,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
