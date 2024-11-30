import 'package:conquest/features/Community/Post/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MediaCarouselWidget extends StatefulWidget {
  final List<String> mediaUrls;
  final double? height;

  const MediaCarouselWidget({
    super.key,
    required this.mediaUrls,
    this.height,
  });

  @override
  _MediaCarouselWidgetState createState() => _MediaCarouselWidgetState();
}

class _MediaCarouselWidgetState extends State<MediaCarouselWidget> {
  late CarouselSliderController _carouselController;
  int _currentIndex = 0;
  final List<Widget> _mediaWidgets = [];

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
    _prepareMediaWidgets();
  }

  void _prepareMediaWidgets() {
    _mediaWidgets.clear();
    for (var mediaUrl in widget.mediaUrls) {
      _mediaWidgets.add(_buildMediaItem(mediaUrl));
    }
  }

  bool _isVideoUrl(String url) {
    return url.contains('.mp4') || url.contains('.mov');
  }

  Widget _buildMediaItem(String mediaUrl) {
    return _isVideoUrl(mediaUrl)
        ? VideoPlayerWidget(videoUrl: mediaUrl)
        : CachedNetworkImage(
            imageUrl: mediaUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
                color: Colors.grey.shade300,
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaUrls.isEmpty) return const SizedBox.shrink();

    return Stack(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: widget.mediaUrls.length,
          itemBuilder: (context, index, realIndex) {
            return _buildMediaItem(widget.mediaUrls[index]);
          },
          options: CarouselOptions(
            height: widget.height ?? 400,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),

        // Media Count Indicator
        if (widget.mediaUrls.length > 1)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentIndex + 1}/${widget.mediaUrls.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

        // Page Indicator for Multiple Media
        if (widget.mediaUrls.length > 1)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedSmoothIndicator(
                activeIndex: _currentIndex,
                count: widget.mediaUrls.length,
                effect: WormEffect(
                  dotWidth: 8,
                  dotHeight: 8,
                  activeDotColor: Colors.white,
                  dotColor: Colors.white.withOpacity(0.4),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
