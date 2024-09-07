class CategoryModel {
  final String id;
  final String name;
  final String? image;
  final bool isFeatured;
  final String parentId;


  CategoryModel({
    required this.id,
    required this.name,
    this.image,
    this.parentId = '',
    required this.isFeatured,
  });

  // Factory constructor to create a UserModel instance from Firestore document
  factory CategoryModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CategoryModel(
      id: id,
      name: data['name'] ?? '',
      image: data['image'],
      parentId: data['parentId'] ?? '',
      isFeatured: data['isFeatured'] ?? false,
    );
  }

  // Method to convert a UserModel into a Map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'parentId': parentId,
      'image': image,
      'name': name,
      'isFeatured': isFeatured,
    };
  }
}
