import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants/colors.dart';

class StoriesWidget extends StatelessWidget {
  final double h;
  final double w;
  const StoriesWidget({super.key, required this.h, required this.w});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stories',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See all',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                height: h * 0.12,
                width: w * 0.2,
                decoration: BoxDecoration(
                  color: Color(0xffD3D5DC),
                  borderRadius: BorderRadius.circular(16),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black26,
                  //     blurRadius: 5,
                  //     offset: Offset(2, 2),
                  //   )
                  // ],
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          TColors.communityPrimary,
                          TColors.communitySecondary
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              buildStoriesWidget(h, w),
              const SizedBox(width: 10),
              buildStoriesWidget(h, w),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildStoriesWidget(double h, double w) {
    return Stack(
      children: [
        Container(
          height: h * 0.12,
          width: w * 0.2,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black26,
            //     blurRadius: 5,
            //     offset: Offset(2, 2),
            //   ),
            // ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Transform.translate(
            offset: Offset(w * 0.07, h * 0.102), // Move the circle half outside
            child: Container(
              height: h * 0.03,
              width: h * 0.03,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
