import 'package:conquest/core/model/community/post_model.dart';

class CommentModel {
  final String commentId;
  final String postId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likeCount;
  final Map<ReactionType, int> reactions;
  final bool isReported;
  final List<String>? reportedBy;

  CommentModel({
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.likeCount = 0,
    this.reactions = const {},
    this.isReported = false,
    this.reportedBy,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['commentId'],
      postId: json['postId'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      likeCount: json['likeCount'] ?? 0,
      reactions: (json['reactions'] as Map?)?.map(
            (key, value) => MapEntry(
              ReactionType.values.firstWhere(
                (e) => e.toString() == key,
                orElse: () => ReactionType.like,
              ),
              value,
            ),
          ) ??
          {},
      isReported: json['isReported'] ?? false,
      reportedBy: List<String>.from(json['reportedBy'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'likeCount': likeCount,
      'reactions':
          reactions.map((key, value) => MapEntry(key.toString(), value)),
      'isReported': isReported,
      'reportedBy': reportedBy,
    };
  }
}
