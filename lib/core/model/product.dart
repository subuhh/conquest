import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String name;
  final String description;
  final int originalPrice;
  final int discountedPrice;
  final String productType;
  final List<String> images;
  final Map<String, dynamic>? clothingAttributes;
  final Map<String, dynamic>? supplementAttributes;
  final DateTime? createdAt;
  final int? quantity;

  ProductModel({
    required this.name,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.productType,
    required this.images,
    this.clothingAttributes,
    this.supplementAttributes,
    this.createdAt,
    this.quantity,
  });

  // Convert product to Firestore map format
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'images': images,
      'type': productType,
      if (clothingAttributes != null) 'clothing': clothingAttributes,
      if (supplementAttributes != null) 'supplement': supplementAttributes,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'quantity': quantity,
    };
  }

  // Create a product from Firestore data
  factory ProductModel.fromFirestore(Map<String, dynamic> data) {
    return ProductModel(
      name: data['name'],
      description: data['description'],
      originalPrice: data['originalPrice'],
      discountedPrice: data['discountedPrice'],
      productType: data['type'],
      images: List<String>.from(data['images'] ?? []),
      clothingAttributes: data['clothing'],
      supplementAttributes: data['supplement'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      quantity: data['quantity'],
    );
  }
}


