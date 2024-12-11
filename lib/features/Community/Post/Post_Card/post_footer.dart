import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/Controllers/community_controller/community_controller.dart';
import '../../../../core/model/community/post_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../Comment/comment_section.dart';

Color? getReactionColor(ReactionType reaction) {
  switch (reaction) {
    case ReactionType.like:
      return Colors.red;
    case ReactionType.inspired:
      return Colors.yellow;
    case ReactionType.motivated:
      return Colors.green;
    case ReactionType.cheered:
      return Colors.blue;
  }
}

class PostFooter extends StatefulWidget {
  final PostModel post;
  final CommunityController controller;

  const PostFooter({super.key, required this.post, required this.controller});

  @override
  _PostFooterState createState() => _PostFooterState();
}

class _PostFooterState extends State<PostFooter> {
  void _showReactionPopup(BuildContext context, Offset offset) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              left: offset.dx - 15, // Adjust positioning as needed
              top: offset.dy - 100, // Position above the favorite icon
              child: ElegantReactionPopup(
                onReactionSelected: (reaction) {
                  widget.controller.reactToPost(widget.post.postId, reaction);
                  Navigator.of(context).pop();
                },
                onCancel: () {
                  Navigator.of(context).pop();
                },
                post: widget.post,
              ),
            ),
          ],
        );
      },
    );
  }

  // Updated method to get the appropriate icon based on the most prominent reaction
  IconData _getReactionIcon() {
    try {
      // Find the reaction with the highest count
      final reactions = widget.post.reactions;

      if (reactions.isEmpty || widget.post.likeCount <= 0) {
        return Icons.favorite_border;
      }

      // Find the reaction type with the highest count
      final mostProminentReaction = reactions.entries
          .reduce(
            (a, b) => a.value > b.value ? a : b,
          )
          .key;

      // Return the appropriate filled icon based on the most prominent reaction
      switch (mostProminentReaction) {
        case ReactionType.like:
          return Icons.favorite;
        case ReactionType.inspired:
          return Icons.lightbulb;
        case ReactionType.motivated:
          return Icons.fitness_center;
        case ReactionType.cheered:
          return Icons.celebration;
        default:
          return Icons.favorite_border;
      }
    } catch (e) {
      // If any error occurs, default to like icon
      return Icons.favorite_border;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Reaction Section
          GestureDetector(
            onLongPressStart: (details) {
              // Get the render box of the gesture detector
              final RenderBox renderBox =
                  context.findRenderObject() as RenderBox;
              final localOffset =
                  renderBox.globalToLocal(details.globalPosition);
              final globalOffset = renderBox.localToGlobal(localOffset);

              _showReactionPopup(context, globalOffset);
            },
            onTap: () {
              widget.controller
                  .reactToPost(widget.post.postId, ReactionType.like);
            },
            child: Row(
              children: [
                // Reaction Icon
                Icon(
                  _getReactionIcon(),
                  color: TColors.primary,
                  size: 26,
                ),

                const SizedBox(width: 8),

                // Reaction Count
                Text(
                  '${widget.post.likeCount}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Comment Section
          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                FitnessCommentBottomSheet(post: widget.post),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            },
            child: Row(
              children: [
                // Comment Count
                Text(
                  '${widget.post.commentCount}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                // Comment Icon
                SvgPicture.asset(
                  'assets/icons/community/comment.svg',
                  height: 25,
                  colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ElegantReactionPopup extends StatefulWidget {
  final void Function(ReactionType) onReactionSelected;
  final VoidCallback onCancel;
  final PostModel post;

  const ElegantReactionPopup({
    Key? key,
    required this.onReactionSelected,
    required this.onCancel,
    required this.post,
  }) : super(key: key);

  @override
  _ElegantReactionPopupState createState() => _ElegantReactionPopupState();
}

class _ElegantReactionPopupState extends State<ElegantReactionPopup>
    with SingleTickerProviderStateMixin {
  ReactionType? _currentReaction;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Create an animation controller for smooth popup appearance
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Create a scale animation for a subtle zoom effect
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    // Start the animation when the widget is initialized
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Method to get reaction icon
  IconData _getReactionIcon(ReactionType reaction) {
    switch (reaction) {
      case ReactionType.like:
        return Icons.favorite;
      case ReactionType.inspired:
        return Icons.lightbulb;
      case ReactionType.motivated:
        return Icons.fitness_center;
      case ReactionType.cheered:
        return Icons.celebration;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          // Determine which reaction is currently selected based on drag position
          final reactionWidth = MediaQuery.of(context).size.width / 5;
          final selectedIndex =
              (details.localPosition.dx / reactionWidth).floor();

          if (selectedIndex >= 0 &&
              selectedIndex < ReactionType.values.length) {
            setState(() {
              _currentReaction = ReactionType.values[selectedIndex];
            });
          }
        },
        onHorizontalDragEnd: (details) {
          if (_currentReaction != null) {
            widget.onReactionSelected(_currentReaction!);
          } else {
            widget.onCancel();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                spreadRadius: 3,
                offset: const Offset(0, 5),
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Reaction icons in a horizontal layout
              ...ReactionType.values.map((reaction) {
                final isSelected = _currentReaction == reaction;
                // Get the count for the current reaction type
                final reactionCount = widget.post.reactions[reaction] ?? 0;

                return GestureDetector(
                  onTap: () => widget.onReactionSelected(reaction),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.grey.shade100
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getReactionIcon(reaction),
                          color: getReactionColor(reaction),
                          size: isSelected ? 32 : 28,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          reactionCount.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
