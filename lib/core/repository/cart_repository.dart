import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/cart_item.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser?.uid ?? '';

  // Reference to the user's cart collection
  CollectionReference get userCartCollection =>
      _firestore.collection('users').doc(userId).collection('cart');

  // Add item to Firebase cart
  Future<void> addItemToCart(CartItemModel cartItem) async {
    try {
      if (cartItem.variationId.isNotEmpty &&
          cartItem.selectedVariation != null) {
        await userCartCollection
            .doc(cartItem.variationId)
            .set(cartItem.toMap());
      } else {
        await userCartCollection.doc(cartItem.productId).set(cartItem.toMap());
      }
      log('Item added to cart in Firestore: ${cartItem.title}');
    } catch (e) {
      log('Error adding item to Firebase cart: $e');
    }
  }

  // Remove item from Firebase cart
  Future<void> removeItemFromCart(String id) async {
    try {
      await userCartCollection.doc(id).delete();
      log('Item removed from cart in Firestore: $id');
    } catch (e) {
      log('Error removing item from Firebase cart: $e');
    }
  }

  // Update item quantity in Firebase cart
  Future<void> updateCartItemQuantity(String variationId, int quantity) async {
    try {
      await userCartCollection.doc(variationId).update({'quantity': quantity});
      log('Cart item quantity updated in Firestore: $variationId');
    } catch (e) {
      log('Error updating cart item quantity in Firebase: $e');
    }
  }

  // Get all items from Firebase cart
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final snapshot = await userCartCollection.get();
      final items = snapshot.docs
          .map((doc) =>
              CartItemModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
      return items;
    } catch (e) {
      log('Error getting Firebase cart items: $e');
      return [];
    }
  }

  // Clear cart in Firebase
  Future<void> clearCart() async {
    try {
      final snapshot = await userCartCollection.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      log('Cart cleared in Firestore');
    } catch (e) {
      log('Error clearing Firebase cart: $e');
    }
  }
}
