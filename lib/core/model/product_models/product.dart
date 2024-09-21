import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conquest/core/model/product_models/product_attribute.dart';
import 'package:conquest/core/model/product_models/product_variations.dart';

class ProductModel {
  String id;
  String stock;
  String sku;
  String price;
  String title;
  DateTime? date;
  String salePrice;
  String thumbnail;
  List<String> images;
  bool isFeatured;
  String description;
  String categoryId;
  String productType;
  List<ProductAttributeModel> productAttributes;
  List<ProductVariationModel> productVariations;

  ProductModel({
    required this.id,
    required this.stock,
    required this.sku,
    required this.price,
    required this.title,
    this.date,
    required this.salePrice,
    required this.thumbnail,
    required this.images,
    required this.isFeatured,
    required this.description,
    required this.categoryId,
    required this.productType,
    required this.productAttributes,
    required this.productVariations,
  });

  factory ProductModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProductModel(
      id: id,
      stock: data['stock'] ?? '',
      sku: data['sku'],
      price: data['price'] ?? '',
      title: data['title'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate(),
      salePrice: data['salePrice'] ?? '',
      thumbnail: data['thumbnail'] ?? '',
      // Cast images as List<String>
      images: List<String>.from(data['images'] ?? []), // Fix here
      isFeatured: data['isFeatured'],
      description: data['description'],
      categoryId: data['categoryId'],
      productType: data['productType'] ?? '',
      productAttributes: (data['productAttributes'] as List<dynamic>?)
          ?.map((attr) => ProductAttributeModel.fromFirestore(attr))
          .toList() ??
          [],
      productVariations: (data['productVariations'] as List<dynamic>?)
          ?.map((varItem) => ProductVariationModel.fromFirestore(varItem))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stock': stock,
      'sku': sku,
      'price': price,
      'title': title,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'salePrice': salePrice,
      'thumbnail': thumbnail,
      'images': images,
      'isFeatured': isFeatured,
      'description': description,
      'categoryId': categoryId,
      'productType': productType,
      'productAttributes': productAttributes.map((e) => e.toMap()).toList(),
      'productVariations': productVariations.map((e) => e.toMap()).toList(),
    };
  }
}
