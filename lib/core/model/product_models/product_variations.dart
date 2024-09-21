class ProductVariationModel {
  String vid;
  String sku;
  String price;
  String? salePrice;
  String stock;
  Map<String, String> attributeValues; // Attribute values such as Color, Size
  List<String>? images; // Images related to variation

  ProductVariationModel({
    required this.vid,
    required this.sku,
    required this.price,
    this.salePrice,
    required this.stock,
    required this.attributeValues,
    this.images,
  });

  static ProductVariationModel empty() => ProductVariationModel(
      vid: '', attributeValues: {}, sku: '', price: '', stock: '');

  factory ProductVariationModel.fromFirestore(Map<String, dynamic> data) {
    return ProductVariationModel(
      vid: data['vid'] as String,
      sku: data['sku'] as String,
      price: data['price'] as String,
      salePrice: data['salePrice'] as String,
      stock: data['stock'] ?? '',
      attributeValues: Map<String, String>.from(data['attributeValues'] ?? {}),
      images: List<String>.from(data['images'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vid': vid,
      'sku': sku,
      'price': price,
      'salePrice': salePrice,
      'stock': stock,
      'attributeValues': attributeValues,
      'images': images,
    };
  }
}
