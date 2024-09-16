class ProductAttributeModel {
  String? name;
  final List<String>? values;

  ProductAttributeModel({this.name, this.values});

  factory ProductAttributeModel.fromFirestore(Map<String, dynamic> data) {
    return ProductAttributeModel(
      name: data.containsKey('name') ? data['name'] : '',
      values: List<String>.from(
          data['values']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'values': values,
    };
  }
}
