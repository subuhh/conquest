class ProductAttributeModel {
  String name;
  List<String> values;

  ProductAttributeModel({
    required this.name,
    required this.values,
  });

  factory ProductAttributeModel.fromFirestore(Map<String, dynamic> data) {
    return ProductAttributeModel(
      name: data['name'] as String,
      values: List<String>.from(data['values'] ?? []), // Ensure it's a list
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'values': values,
    };
  }
}