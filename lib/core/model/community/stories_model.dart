import 'package:cloud_firestore/cloud_firestore.dart';

enum StoryMediaType { image, video }

class StoryModel {
  final String? id;
  final String userId;
  final String mediaUrl;
  final StoryMediaType mediaType;
  final String? caption;
  final DateTime createdAt;
  final DateTime expiresAt;
  final List<String> viewedBy;
  final List<String> likedBy;
  final List<CommentModel> comments; // List of comments on the story
  final String? userAvatar;

  StoryModel({
    this.id,
    required this.userId,
    required this.mediaUrl,
    required this.mediaType,
    required this.userAvatar,
    this.caption,
    DateTime? createdAt,
    DateTime? expiresAt,
    List<String>? viewedBy,
    List<String>? likedBy,
    List<CommentModel>? comments,
  })  : createdAt = createdAt ?? DateTime.now(),
        expiresAt = expiresAt ?? DateTime.now().add(const Duration(hours: 24)),
        viewedBy = viewedBy ?? [],
        likedBy = likedBy ?? [],
        comments = comments ?? [];

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType.toString().split('.').last,
      'caption': caption,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'viewedBy': viewedBy,
      'likedBy': likedBy,
      'comments': comments.map((comment) => comment.toMap()).toList(),
      'userAvatar': userAvatar
    };
  }

  // Create from Firestore document
  factory StoryModel.fromMap(Map<String, dynamic> map, String id) {
    return StoryModel(
      id: id,
      userId: map['userId'],
      mediaUrl: map['mediaUrl'],
      mediaType: StoryMediaType.values.firstWhere(
          (type) => type.toString().split('.').last == map['mediaType']),
      caption: map['caption'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      expiresAt: (map['expiresAt'] as Timestamp).toDate(),
      viewedBy: List<String>.from(map['viewedBy'] ?? []),
      likedBy: List<String>.from(map['likedBy'] ?? []),
      comments: map['comments'] != null
          ? (map['comments'] as List)
              .asMap()
              .entries
              .map((entry) =>
                  CommentModel.fromMap(entry.value, entry.key.toString()))
              .toList()
          : [],
      userAvatar: map['userAvatar'] ?? '',
    );
  }

  // Check if story is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

// Comment model to represent comments on a story
class CommentModel {
  final String? id;
  final String userId; // ID of the user who made the comment
  final String text; // Content of the comment
  final DateTime createdAt; // Timestamp of the comment
  final String? userAvatar; // Avatar of the commenter

  CommentModel({
    this.id,
    required this.userId,
    required this.text,
    DateTime? createdAt,
    this.userAvatar,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert comment to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
      'userAvatar': userAvatar,
    };
  }

  // Create comment from Firestore document
  factory CommentModel.fromMap(Map<String, dynamic> map, String id) {
    return CommentModel(
      id: id,
      userId: map['userId'],
      text: map['text'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      userAvatar: map['userAvatar'],
    );
  }
}
