import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    } catch (e) {
      log('Error fetching featured products: $e');
      Get.snackbar('Error', 'Could not fetch featured products');
      rethrow;
    }
  }

  // Fetching all Products
  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      final snapshot = await _db.collection('products').get();
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      log('Error fetching the products: $e');
      Get.snackbar('Error', 'Could not fetch products');
      rethrow;
    }
  }
}
