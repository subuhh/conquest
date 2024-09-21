class CartItemModel {
  String productId;
  String title;
  String price;
  String? image;
  int quantity;
  String variationId;
  Map<String, String>? selectedVariation;

  CartItemModel({
    required this.productId,
    this.title = '',
    this.price = '',
    this.image,
    required this.quantity,
    this.variationId = '',
    this.selectedVariation,
  });

  static CartItemModel empty() => CartItemModel(productId: '', quantity: 0);

  factory CartItemModel.fromFirestore(
      Map<String, dynamic> data) {
    return CartItemModel(
      productId: data['productId'],
      title: data['title'] ?? '',
      price: data['price'],
      image: data['image'] ?? '',
      quantity: data['quantity'] ?? '',
      variationId: data['variationId'] ?? '',
      selectedVariation: data['selectedVariation'] != null
          ? Map<String, String>.from(data['selectedVariation'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
      'variationId': variationId,
      'selectedVariation': selectedVariation,
    };
  }
}
