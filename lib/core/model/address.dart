class AddressModel {
  final String id; // Unique identifier for the address (e.g., UUID)
  final String userId; // ID of the user to whom this address belongs
  final String recipientName; // Name of the person receiving the delivery
  final String phoneNumber; // Recipient's phone number
  final String email; // Optional: Recipient's email
  final String houseNumber; // House/Apartment number
  final String streetAddress; // Street address or road name
  final String landmark; // Optional: Nearby landmark
  final String area; // Neighborhood or area
  final String city; // City or town name
  final String state; // State or province
  final String postalCode; // Zip or postal code
  final String country; // Country name
  final AddressType addressType; // Enum: Home, Work, Other
  final String floor; // Optional: Floor/level in a building
  final String towerOrBlock; // Optional: Tower/Block information
  final bool isDefault; // Is this the default address for the user

  AddressModel({
    required this.id,
    required this.userId,
    required this.recipientName,
    required this.phoneNumber,
    required this.email,
    required this.houseNumber,
    required this.streetAddress,
    required this.landmark,
    required this.area,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.addressType,
    required this.isDefault,
    this.floor = '',
    this.towerOrBlock = '',
  });

  // Convert AddressModel to Map (for Firebase or other NoSQL databases)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'recipientName': recipientName,
      'phoneNumber': phoneNumber,
      'email': email,
      'houseNumber': houseNumber,
      'streetAddress': streetAddress,
      'landmark': landmark,
      'area': area,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'addressType': addressType.name,
      'isDefault': isDefault,
      'floor': floor,
      'towerOrBlock': towerOrBlock,
    };
  }

  // Create AddressModel from Map (for deserializing)
  factory AddressModel.fromFirestore(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'],
      userId: map['userId'],
      recipientName: map['recipientName'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      houseNumber: map['houseNumber'],
      streetAddress: map['streetAddress'],
      landmark: map['landmark'] ?? '',
      area: map['area'],
      city: map['city'],
      state: map['state'],
      postalCode: map['postalCode'],
      country: map['country'],
      addressType: AddressType.values.firstWhere(
              (e) => e.name == map['addressType'], orElse: () => AddressType.other),
      isDefault: map['isDefault'],
      floor: map['floor'] ?? '',
      towerOrBlock: map['towerOrBlock'] ?? '',
    );
  }
}

// Enum to handle different types of addresses
enum AddressType {
  home,
  work,
  other,
}
