class UserModel {
  final String id;
  final String userName; // Username as the unique identifier
  final String email;
  final String name;
  final String phoneNumber;
  final String? profileImageUrl;
  final String? bio;
  final int? age;
  final String? gender;
  final double? height;
  final double? weight;
  final String? fitnessGoal;
  final List<String>? workoutHistory;
  final String? defaultAddressId;

  UserModel({
    required this.id,
    required this.userName, // Renamed userId to userName
    required this.email,
    required this.name,
    required this.phoneNumber,
    this.profileImageUrl,
    this.bio,
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.fitnessGoal,
    this.workoutHistory,
    this.defaultAddressId
  });

  // Factory constructor to create a UserModel instance from Firestore document
  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      userName: data['userName'],
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      bio: data['bio'] ?? '',
      age: data['age'] ?? 0,
      gender: data['gender'] ?? '',
      height: data['height']?.toDouble() ?? 0.0,
      weight: data['weight']?.toDouble() ?? 0.0,
      fitnessGoal: data['fitnessGoal'] ?? '',
      workoutHistory: List<String>.from(data['workoutHistory'] ?? []),
      defaultAddressId: data['defaultAddressId'] ?? '',
    );
  }

  // Method to convert a UserModel into a Map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'userName': userName,
      'name': name,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'fitnessGoal': fitnessGoal,
      'workoutHistory': workoutHistory,
      'defaultAddressId': defaultAddressId
    };
  }
}
