import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conquest/utils/exceptions/firebase_exceptions.dart';
import 'package:conquest/utils/exceptions/platform_exceptions.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../model/Product_Models/product.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  // Fetching Featured Products
  Future<List<ProductModel>> fetchFeaturedProducts() async {
    try {
      final snapshot = await _db
          .collection('products')
          .where('isFeatured', isEqualTo: true)
          .limit(5)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Fetching all Products
  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      final snapshot = await _db.collection('products').get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Fetching favorites products
  Future<List<ProductModel>> getFavoriteProducts(
      List<String> productsId) async {
    try {
      // Check if the productsId list is empty
      if (productsId.isEmpty) {
        return []; // Return an empty list if no products are in the favorites
      }

      final snapshot = await _db
          .collection('products')
          .where(FieldPath.documentId, whereIn: productsId)
          .get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      log('Wishlist: $e');
      throw 'Something went wrong. Please try again';
    }
  }
}
