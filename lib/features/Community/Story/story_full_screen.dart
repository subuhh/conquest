import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_view/story_view.dart';

import '../../../core/model/community/stories_model.dart';
import '../../../core/Controllers/community_controller/stories_controller.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<StoryModel> stories;

  const StoryViewerScreen({Key? key, required this.stories}) : super(key: key);

  @override
  _StoryViewerScreenState createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  final StoryController _storyController = StoryController();
  final FocusNode _commentFocusNode = FocusNode();
  final TextEditingController _commentController = TextEditingController();
  List<StoryItem> _storyItems = [];
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _prepareStories();

    // Add listener to handle focus changes
    _commentFocusNode.addListener(() {
      if (_commentFocusNode.hasFocus) {
        // Pause the story when text field is focused
        _storyController.pause();
        setState(() {
          _isPaused = true;
        });
      } else {
        // Resume the story when focus is lost
        _storyController.play();
        setState(() {
          _isPaused = false;
        });
      }
    });
  }

  void _prepareStories() {
    _storyItems = widget.stories.map((story) {
      // Mark story as viewed
      StoriesController.instance.viewStory(story);

      // Different handling based on media type
      switch (story.mediaType) {
        case StoryMediaType.image:
          return StoryItem.pageImage(
            url: story.mediaUrl,
            controller: _storyController,
            caption: Text(story.caption ?? ''),
            imageFit: BoxFit.contain,
          );
        case StoryMediaType.video:
          return StoryItem.pageVideo(
            story.mediaUrl,
            controller: _storyController,
            caption: Text(story.caption ?? ''),
          );
        default:
          return StoryItem.text(
            title: 'Unsupported media type',
            backgroundColor: Colors.black,
          );
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside the text field
        if (_commentFocusNode.hasFocus) {
          _commentFocusNode.unfocus();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            StoryView(
              storyItems: _storyItems,
              controller: _storyController,
              inline: false,
              repeat: false,
              onStoryShow: (storyItem, index) {},
              onComplete: () {
                Get.back();
              },
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down || direction == Direction.up) {
                  Get.back();
                }
              },
            ),

            // Custom Comment TextField
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: _buildCommentTextField(),
            ),

            // Like Button (Optional)
            Positioned(
              bottom: 20,
              right: 16,
              child: _buildLikeButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentTextField() {
    return TextField(
      controller: _commentController,
      focusNode: _commentFocusNode,
      decoration: InputDecoration(
        hintText: 'Add a comment...',
        hintStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.black.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
      style: TextStyle(color: Colors.white),
      onSubmitted: (text) {
        if (text.isNotEmpty) {
          // Get current story index
          final currentStoryIndex =
              _storyController.playbackNotifier.value.index;

          // Add comment to the current story
          StoriesController.instance.addCommentToStory(
            storyId: widget.stories[currentStoryIndex].id!,
            userId: widget.stories[currentStoryIndex].userId,
            text: text,
            userAvatar: widget.stories[currentStoryIndex].userAvatar,
          );

          // Clear the text field and remove focus
          _commentController.clear();
          _commentFocusNode.unfocus();
        }
      },
    );
  }

  Widget _buildLikeButton() {
    return IconButton(
      icon: Icon(Icons.favorite_border, color: Colors.white, size: 30),
      onPressed: () {
        // Get current story index
        final currentStoryIndex = _storyController.playbackNotifier.value.index;

        // Like the current story
        StoriesController.instance.likeStory(widget.stories[currentStoryIndex]);
      },
    );
  }

  @override
  void dispose() {
    _storyController.dispose();
    _commentFocusNode.dispose();
    _commentController.dispose();
    super.dispose();
  }
}
