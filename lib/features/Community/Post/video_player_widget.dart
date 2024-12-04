import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../utils/constants/colors.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isMuted = false;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    if (!_isInitialized) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      _initializeVideoPlayerFuture = _controller.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _controller.setLooping(true);
            _controller.play();
            _isPlaying = true;
            _controller.setVolume(1.0);

            // Add listener to update playing state
            _controller.addListener(_updatePlayingState);
          });
        }
      });
    }
  }

  void _updatePlayingState() {
    if (mounted) {
      final wasPlaying = _isPlaying;
      final currentlyPlaying = _controller.value.isPlaying;

      if (wasPlaying != currentlyPlaying) {
        setState(() {
          _isPlaying = currentlyPlaying;
        });
      }
    }
  }

  void _togglePlayPause() {
    if (!_isInitialized) return;

    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _toggleVolume() {
    if (!_isInitialized) return;

    setState(() {
      if (_isMuted) {
        _controller.setVolume(1.0); // Unmute
      } else {
        _controller.setVolume(0.0); // Mute
      }
      _isMuted = !_isMuted;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (visibilityInfo) {
        if (!_isInitialized) return;

        final visiblePercentage = visibilityInfo.visibleFraction;
        if (visiblePercentage <= 0) {
          // Video is not visible, pause
          _controller.pause();
        } else if (visiblePercentage > 0) {
          // Video is visible, play
          _controller.play();
        }
      },
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _isInitialized) {
            return GestureDetector(
              onTap: _togglePlayPause,
              child: AspectRatio(
                aspectRatio: 9/16,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_controller),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 50),
                      reverseDuration: const Duration(milliseconds: 200),
                      child: !_isPlaying
                          ? Icon(
                              Icons.play_circle_fill,
                              key: const ValueKey('playIcon'),
                              size: 70,
                              color: Colors.white.withOpacity(0.7),
                            )
                          : const SizedBox.shrink(
                              key: ValueKey('emptyIcon'),
                            ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: _toggleVolume,
                        child: Icon(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: TColors.primary,
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_updatePlayingState);
    _controller.dispose();
    super.dispose();
  }
}
