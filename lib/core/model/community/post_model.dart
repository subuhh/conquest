class PostModel {
  // Post Metadata
  final String postId;
  final String userId;
  final String userName;
  final String userAvatar;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Post Content
  final PostType postType; // Enum for post type
  final String? content; // For text posts
  final List<String>? mediaUrls; // Images/Videos
  final PollData? pollData; // Optional for poll posts
  final ChallengeData? challengeData; // Optional for challenge posts

  // Engagement Data
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final Map<ReactionType, int> reactions; // Enum-based reactions

  // Tags and Categorization
  final List<String>? hashtags;
  final Category? category; // Enum-based category
  final String? location;

  // Privacy and Moderation
  final Visibility visibility; // Enum-based visibility
  final bool isReported;
  final List<String>? reportedBy;

  // Additional Features
  final List<String>? taggedUsers;
  final List<String>? savedBy;
  final List<String>? viewers;
  final Map<String, dynamic>? metadata;

  // Constructor
  PostModel({
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.createdAt,
    this.updatedAt,
    required this.postType,
    this.content,
    this.mediaUrls,
    this.pollData,
    this.challengeData,
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.reactions = const {},
    this.hashtags,
    this.category,
    this.location,
    this.visibility = Visibility.public,
    this.isReported = false,
    this.reportedBy,
    this.taggedUsers,
    this.savedBy,
    this.viewers,
    this.metadata,
  });

  // JSON Serialization
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      postType: PostType.values.firstWhere(
        (e) => e.toString() == json['postType'],
        orElse: () => PostType.image, // Default to image if not found
      ),
      content: json['content'],
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      pollData:
          json['pollData'] != null ? PollData.fromJson(json['pollData']) : null,
      challengeData: json['challengeData'] != null
          ? ChallengeData.fromJson(json['challengeData'])
          : null,
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
      reactions: (json['reactions'] as Map?)?.map(
            (key, value) {
              return MapEntry(
                ReactionType.values.firstWhere(
                  (e) => e.toString() == key,
                  orElse: () => ReactionType.like,
                ),
                value is int
                    ? value
                    : 0, // Ensure the value is an integer, defaulting to 0 if not
              );
            },
          ) ??
          {},
      hashtags: List<String>.from(json['hashtags'] ?? []),
      category: json['category'] != null
          ? Category.values.firstWhere(
              (e) => e.toString() == json['category'],
              orElse: () => Category.workout, // Default to general if not found
            )
          : null,
      location: json['location'],
      visibility: Visibility.values.firstWhere(
        (e) => e.toString() == json['visibility'],
        orElse: () => Visibility.public, // Default to public if not found
      ),
      isReported: json['isReported'] ?? false,
      reportedBy: List<String>.from(json['reportedBy'] ?? []),
      taggedUsers: List<String>.from(json['taggedUsers'] ?? []),
      savedBy: List<String>.from(json['savedBy'] ?? []),
      viewers: List<String>.from(json['viewers'] ?? []),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'postType': postType.toString(),
      'content': content,
      'mediaUrls': mediaUrls,
      'pollData': pollData?.toJson(),
      'challengeData': challengeData?.toJson(),
      'likeCount': likeCount,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'reactions':
          reactions.map((key, value) => MapEntry(key.toString(), value)),
      'hashtags': hashtags,
      'category': category?.toString(),
      'location': location,
      'visibility': visibility.toString(),
      'isReported': isReported,
      'reportedBy': reportedBy,
      'taggedUsers': taggedUsers,
      'savedBy': savedBy,
      'viewers': viewers,
      'metadata': metadata,
    };
  }

  // CopyWith Method
  PostModel copyWith({
    String? postId,
    String? userId,
    String? userName,
    String? userAvatar,
    DateTime? createdAt,
    DateTime? updatedAt,
    PostType? postType,
    String? content,
    List<String>? mediaUrls,
    PollData? pollData,
    ChallengeData? challengeData,
    int? likeCount,
    int? commentCount,
    int? shareCount,
    Map<ReactionType, int>? reactions,
    List<String>? hashtags,
    Category? category,
    String? location,
    Visibility? visibility,
    bool? isReported,
    List<String>? reportedBy,
    List<String>? taggedUsers,
    List<String>? savedBy,
    List<String>? viewers,
    Map<String, dynamic>? metadata,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      postType: postType ?? this.postType,
      content: content ?? this.content,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      pollData: pollData ?? this.pollData,
      challengeData: challengeData ?? this.challengeData,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      reactions: reactions ?? this.reactions,
      hashtags: hashtags ?? this.hashtags,
      category: category ?? this.category,
      location: location ?? this.location,
      visibility: visibility ?? this.visibility,
      isReported: isReported ?? this.isReported,
      reportedBy: reportedBy ?? this.reportedBy,
      taggedUsers: taggedUsers ?? this.taggedUsers,
      savedBy: savedBy ?? this.savedBy,
      viewers: viewers ?? this.viewers,
      metadata: metadata ?? this.metadata,
    );
  }
}

class PollData {
  final String question;
  final List<String> options; // Poll options
  final PollOptionType optionType; // Enum for single/multiple choice
  final Map<int, int> votes; // Option index -> Vote count

  PollData({
    required this.question,
    required this.options,
    required this.optionType,
    this.votes = const {},
  });

  factory PollData.fromJson(Map<String, dynamic> json) {
    return PollData(
      question: json['question'],
      options: List<String>.from(json['options']),
      optionType: PollOptionType.values.firstWhere(
        (e) => e.toString() == json['optionType'],
        orElse: () =>
            PollOptionType.singleChoice, // Default to single if not found
      ),
      votes: Map<int, int>.from(json['votes'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'optionType': optionType.toString(),
      'votes': votes,
    };
  }
}

class ChallengeData {
  final String title;
  final String description;
  final ChallengeType challengeType; // Enum for challenge type
  final DateTime startDate;
  final DateTime endDate;
  final List<String> participants; // User IDs participating

  ChallengeData({
    required this.title,
    required this.description,
    required this.challengeType,
    required this.startDate,
    required this.endDate,
    this.participants = const [],
  });

  factory ChallengeData.fromJson(Map<String, dynamic> json) {
    return ChallengeData(
      title: json['title'],
      description: json['description'],
      challengeType: ChallengeType.values.firstWhere(
        (e) => e.toString() == json['challengeType'],
        orElse: () => ChallengeType.fitness, // Default to fitness if not found
      ),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      participants: List<String>.from(json['participants'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'challengeType': challengeType.toString(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'participants': participants,
    };
  }
}

// Enum for Post Types
enum PostType { text, image, video, poll, challenge, story }

// Enum for Poll Options
enum PollOptionType { singleChoice, multipleChoice }

// Enum for Challenge Type
enum ChallengeType { fitness, diet, transformation }

// Enum for Visibility Options
enum Visibility { public, friends, private }

// Enum for Reaction Types
enum ReactionType { like, inspired, motivated, cheered }

// Enum for Post Categories
enum Category { all, workout, nutrition, transformation }
