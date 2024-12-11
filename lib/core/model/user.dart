import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String userName; // Username as the unique identifier
  final String email;
  final String name;
  final String phoneNumber;
  final String? profileImageUrl;
  final String? bannerImageUrl;
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
  final WaterGoal? waterGoal; // Changed from double to WaterGoal
  final double? proteinGoal;
  final double? fatGoal;
  final double? carbsGoal;
  final double? fiberGoal;
  final DateTime? accountCreationTime;
  final String? assignedWorkout;
  final List<String>? previouslyGeneratedRecipes;
  final List<String>? favoriteRecipes;
  final int? totalPost;
  final int? totalFollowers;
  final int? totalFollowing;

  UserModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.name,
    required this.phoneNumber,
    this.bannerImageUrl,
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
    this.assignedWorkout,
    this.previouslyGeneratedRecipes,
    this.favoriteRecipes,
    this.totalPost,
    this.totalFollowers,
    this.totalFollowing,
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
      bannerImageUrl: data['bannerImageUrl'] ?? '',
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
      waterGoal: data['waterGoal'] != null
          ? WaterGoal.fromMap(data['waterGoal'])
          : null,
      // Parse waterGoal map
      proteinGoal: data['proteinGoal']?.toDouble() ?? 0.0,
      fatGoal: data['fatGoal']?.toDouble() ?? 0.0,
      carbsGoal: data['carbsGoal']?.toDouble() ?? 0.0,
      fiberGoal: data['fiberGoal']?.toDouble() ?? 0.0,
      accountCreationTime:
          (data['accountCreationTime'] as Timestamp?)?.toDate(),
      assignedWorkout: data['assignedWorkout'] ?? '',
      previouslyGeneratedRecipes:
          List<String>.from(data['previouslyGeneratedRecipes'] ?? []),
      favoriteRecipes: List<String>.from(data['favoriteRecipes'] ?? []),
      totalPost: data['totalPost'] ?? 0,
      totalFollowing: data['totalFollowing'] ?? 0,
      totalFollowers: data['totalFollowers'] ?? 0,
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
      'bannerImageUrl': bannerImageUrl,
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
      'waterGoal': waterGoal?.toMap(), // Convert WaterGoal to map
      'proteinGoal': proteinGoal,
      'fatGoal': fatGoal,
      'carbsGoal': carbsGoal,
      'fiberGoal': fiberGoal,
      'accountCreationTime': accountCreationTime != null
          ? Timestamp.fromDate(accountCreationTime!)
          : null,
      'assignedWorkout': assignedWorkout,
      'previouslyGeneratedRecipes': previouslyGeneratedRecipes ?? [],
      'favoriteRecipes': favoriteRecipes ?? [],
      'totalPost': totalPost,
      'totalFollowing': totalFollowing,
      'totalFollowers': totalFollowers,
    };
  }

  // Method to copy UserModel with some updated fields
  UserModel copyWith({
    String? id,
    String? userName,
    String? email,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
    String? bannerImageUrl,
    String? bio,
    int? age,
    String? gender,
    double? height,
    double? weight,
    double? weightGoal,
    List<String>? fitnessGoal,
    String? workoutFrequency,
    List<String>? workoutHistory,
    List<String>? dietPreference,
    String? defaultAddressId,
    double? calorieGoal,
    WaterGoal? waterGoal,
    double? proteinGoal,
    double? fatGoal,
    double? carbsGoal,
    double? fiberGoal,
    DateTime? accountCreationTime,
    String? assignedWorkout,
    List<String>? previouslyGeneratedRecipes,
    List<String>? favoriteRecipes,
    int? totalPost,
    int? totalFollowers,
    int? totalFollowing,
  }) {
    return UserModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bannerImageUrl: bannerImageUrl ?? this.bannerImageUrl,
      bio: bio ?? this.bio,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      weightGoal: weightGoal ?? this.weightGoal,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      workoutFrequency: workoutFrequency ?? this.workoutFrequency,
      workoutHistory: workoutHistory ?? this.workoutHistory,
      dietPreference: dietPreference ?? this.dietPreference,
      defaultAddressId: defaultAddressId ?? this.defaultAddressId,
      calorieGoal: calorieGoal ?? this.calorieGoal,
      waterGoal: waterGoal ?? this.waterGoal,
      proteinGoal: proteinGoal ?? this.proteinGoal,
      fatGoal: fatGoal ?? this.fatGoal,
      carbsGoal: carbsGoal ?? this.carbsGoal,
      fiberGoal: fiberGoal ?? this.fiberGoal,
      accountCreationTime: accountCreationTime ?? this.accountCreationTime,
      assignedWorkout: assignedWorkout ?? this.assignedWorkout,
      previouslyGeneratedRecipes:
          previouslyGeneratedRecipes ?? this.previouslyGeneratedRecipes,
      favoriteRecipes: favoriteRecipes ?? this.favoriteRecipes,
      totalPost: totalPost ?? this.totalPost,
      totalFollowers: totalFollowers ?? this.totalFollowers,
      totalFollowing: totalFollowing ?? this.totalFollowing,
    );
  }
}

// WaterGoal model to handle amount and unit
class WaterGoal {
  final int amount; // Water goal amount
  final String unit; // Unit (e.g., "ml", "oz", "L")

  WaterGoal({
    required this.amount,
    required this.unit,
  });

  // Factory method to create a WaterGoal from a Firestore map
  factory WaterGoal.fromMap(Map<String, dynamic> map) {
    return WaterGoal(
      amount: map['amount']?.toInt() ?? 0,
      unit: map['unit'] ?? 'L', // Default to L
    );
  }

  // Method to convert a WaterGoal to a map
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'unit': unit,
    };
  }
}
