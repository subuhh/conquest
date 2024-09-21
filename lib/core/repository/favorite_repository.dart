import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteRepository {
  static final FavoriteRepository instance = FavoriteRepository._();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get userId => _auth.currentUser?.uid ?? '';

  FavoriteRepository._();

  // Get user favorites from Firestore
  Future<Map<String, bool>> getFavoritesFromFirebase() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();

    // Convert Firestore documents into a Map of favorites
    return Map.fromEntries(snapshot.docs.map(
      (doc) => MapEntry(doc.id, true),
    ));
  }

  // Add favorite to Firestore
  Future<void> addFavoriteToFirebase(String productId) async {
    log('Favorite added to firebase');
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(productId)
        .set({'favorite': true});
  }

  // Remove favorite from Firestore
  Future<void> removeFavoriteFromFirebase(String productId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(productId)
        .delete();
  }
}
