import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/model/banner.dart';

class CarouselSection extends StatefulWidget {
  final bool isLoading;
  final List<BannerModel> banners;
  const CarouselSection({
    super.key,
    required this.isLoading,
    required this.banners,
  });

  @override
  State<CarouselSection> createState() => _CarouselSectionState();
}

class _CarouselSectionState extends State<CarouselSection> {
  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? _buildShimmerPlaceholder()
        : CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1.0,
              enableInfiniteScroll: true,
            ),
            items: List.generate(widget.banners.length, (index) {
              final banner = widget.banners[index];
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    // onTap: () => Navigator.pushNamed(
                    //   context,
                    //   banner.onTapScreen,
                    // ),
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          imageUrl: banner.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, value) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200.0,
                              color: Colors.grey[200],
                            );
                          },
                        ),
                        // Image.network(
                        //   banner.imageUrl,
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
