class ProductVariationModel {
  final String id;
  String? sku;
  String? description;
  String? price;
  String? salePrice;
  String? stock;
  Map<String, String> attributeValues;
  List<String> images; // New field to hold image URLs for each variation

  ProductVariationModel({
    required this.id,
    this.sku,
    this.description,
    this.price,
    this.salePrice,
    this.stock,
    required this.attributeValues,
    required this.images, // Initialize this in the constructor
  });

  static ProductVariationModel empty() =>
      ProductVariationModel(id: '', attributeValues: {}, images: []);

  factory ProductVariationModel.fromFirestore(
      Map<String, dynamic> data, String id) {
    return ProductVariationModel(
      id: id,
      sku: data['sku'] ?? '',
      description: data['description'],
      price: data['price']?.toString() ?? '',
      salePrice: data['salePrice']?.toString() ?? '',
      stock: data['stock']?.toString() ?? '',
      attributeValues: Map<String, String>.from(data['attributeValues'] ?? {}),
      images: List<String>.from(data['images'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sku': sku,
      'description': description,
      'price': price,
      'salePrice': salePrice,
      'stock': stock,
      'attributeValues': attributeValues,
      'images': images, // Include images in the map
    };
  }
}
