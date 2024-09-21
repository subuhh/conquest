import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product_models/review.dart';

class ReviewRepository {
  static ReviewRepository instance = ReviewRepository();

  final _firestore = FirebaseFirestore.instance;

  Future<void> addReview({
    required String userId,
    required String productId,
    required double rating,
    required String reviewText,
    required String username,
    required String title,
    List<File>? imageFiles,
  }) async {
    try {
      await _firestore.collection('reviews').add({
        'userId': userId,
        'productId': productId,
        'rating': rating,
        'reviewText': reviewText,
        'timestamp': FieldValue.serverTimestamp(),
        'username': username,
        'title': title,
      });

      log('Review added successfully');
    } catch (e) {
      log('Failed to add review: $e');
      throw 'Error adding review';
    }
  }

  Stream<List<ReviewModel>> streamProductReviews(String productId) {
    return _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ReviewModel.fromFirestore(doc.data()))
        .toList());
  }

  Stream<Map<String, dynamic>> streamRatingSummary(String productId) {
    return _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return {
          'averageRating': 0.0,
          'totalReviews': 0,
          'ratingDistribution': {5: 0, 4: 0, 3: 0, 2: 0, 1: 0},
        };
      }

      double totalRating = 0.0;
      int totalReviews = snapshot.docs.length;
      Map<int, int> ratingDistribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

      for (var doc in snapshot.docs) {
        double rating = (doc['rating'] is int)
            ? (doc['rating'] as int).toDouble()
            : doc['rating'] as double;

        totalRating += rating;
        ratingDistribution[rating.toInt()] = ratingDistribution[rating.toInt()]! + 1;
      }

      double averageRating = totalRating / totalReviews;

      return {
        'averageRating': averageRating,
        'totalReviews': totalReviews,
        'ratingDistribution': ratingDistribution,
      };
    });
  }

}
