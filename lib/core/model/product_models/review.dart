import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String userId;
  final String productId;
  final String username;
  final String title;
  final String reviewText;
  final double rating;
  final DateTime timestamp;

  ReviewModel({
    required this.userId,
    required this.productId,
    required this.username,
    required this.title,
    required this.reviewText,
    required this.rating,
    required this.timestamp,
  });

  factory ReviewModel.fromFirestore(Map<String, dynamic> data) {
    return ReviewModel(
      userId: data['userId'],
      productId: data['productId'],
      username: data['username'],
      title: data['title'],
      reviewText: data['reviewText'],
      rating: data['rating'].toDouble(),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productId': productId,
      'username': username,
      'title': title,
      'reviewText': reviewText,
      'rating': rating,
      'timestamp': timestamp,
    };
  }
}
