class BannerModel {
  final String id;
  final String targetScreen;
  final String onTapScreen;
  final String imageUrl;
  final bool active;

  BannerModel({
    required this.id,
    required this.targetScreen,
    required this.onTapScreen,
    required this.imageUrl,
    required this.active,
  });

  // Factory constructor to create a UserModel instance from Firestore document
  factory BannerModel.fromFirestore(Map<String, dynamic> data, String id) {
    return BannerModel(
      id: id,
      targetScreen: data['targetScreen'] ?? '',
      onTapScreen: data['onTapScreen'] ?? '',
      imageUrl: data['imageUrl'],
      active: data['active'] ?? false,
    );
  }

  // Method to convert a UserModel into a Map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'targetScreen': targetScreen,
      'onTapScreen': onTapScreen,
      'active': active,
    };
  }
}
