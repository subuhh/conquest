import 'package:cloud_firestore/cloud_firestore.dart';

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
  final double? weightGoal;
  final List<String>? fitnessGoal;
  final String? workoutFrequency;
  final List<String>? workoutHistory;
  final List<String>? dietPreference;
  final String? defaultAddressId;
  final double? calorieGoal;
  final double? waterGoal;
  final double? proteinGoal;
  final double? fatGoal;
  final double? carbsGoal;
  final double? fiberGoal;
  final DateTime? accountCreationTime;

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
    this.weightGoal,
    this.fitnessGoal,
    this.workoutFrequency,
    this.workoutHistory,
    this.dietPreference,
    this.defaultAddressId,
    this.calorieGoal,
    this.waterGoal,
    this.proteinGoal,
    this.fatGoal,
    this.carbsGoal,
    this.fiberGoal,
    this.accountCreationTime,
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
      weightGoal: data['weightGoal']?.toDouble() ?? 0.0,
      workoutFrequency: data['workoutFrequency'] ?? '',
      fitnessGoal: List<String>.from(data['fitnessGoal'] ?? []),
      workoutHistory: List<String>.from(data['workoutHistory'] ?? []),
      dietPreference: List<String>.from(data['dietPreference'] ?? []),
      defaultAddressId: data['defaultAddressId'] ?? '',
      calorieGoal: data['calorieGoal'] ?? 0.0,
      waterGoal: data['waterGoal'] ?? 0.0,
      proteinGoal: data['proteinGoal']?.toDouble() ?? 0.0,
      fatGoal: data['fatGoal']?.toDouble() ?? 0.0,
      carbsGoal: data['carbsGoal']?.toDouble() ?? 0.0,
      fiberGoal: data['fiberGoal']?.toDouble() ?? 0.0,
      accountCreationTime:
          (data['accountCreationTime'] as Timestamp?)?.toDate(),
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
      'weightGoal': weightGoal,
      'fitnessGoal': fitnessGoal,
      'workoutFrequency': workoutFrequency,
      'workoutHistory': workoutHistory,
      'dietPreference': dietPreference,
      'defaultAddressId': defaultAddressId,
      'calorieGoal': calorieGoal,
      'waterGoal': waterGoal,
      'proteinGoal': proteinGoal,
      'fatGoal': fatGoal,
      'carbsGoal': carbsGoal,
      'fiberGoal': fiberGoal,
      'accountCreationTime': accountCreationTime != null
          ? Timestamp.fromDate(accountCreationTime!)
          : null,
    };
  }
}
