class AddressModel {
  final String id; // Unique identifier for the address (e.g., UUID)
  final String recipientName; // Name of the person receiving the delivery
  final String phoneNumber; // Recipient's phone number
  final String houseNumber; // House/Apartment number
  final String streetAddress; // Street address or road name
  final String landmark; // Optional: Nearby landmark
  final String city; // City or town name
  final String state; // State or province
  final String postalCode; // Zip or postal code
  final String addressType; // Enum: Home, Work, Other
  final String floor; // Optional: Floor/level in a building
  final String towerOrBlock; // Optional: Tower/Block information
  final bool isDefault; // Is this the default address for the user

  AddressModel({
    required this.id,
    required this.recipientName,
    required this.phoneNumber,
    required this.houseNumber,
    required this.streetAddress,
    this.landmark = '',
    required this.city,
    required this.state,
    required this.postalCode,
    required this.addressType,
    this.isDefault = false,
    this.floor = '',
    this.towerOrBlock = '',
  });

  // Convert AddressModel to Map (for Firebase or other NoSQL databases)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipientName': recipientName,
      'phoneNumber': phoneNumber,
      'houseNumber': houseNumber,
      'streetAddress': streetAddress,
      'landmark': landmark,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'addressType': addressType,
      'isDefault': isDefault,
      'floor': floor,
      'towerOrBlock': towerOrBlock,
    };
  }

  // Create AddressModel from Map (for deserializing)
  factory AddressModel.fromFirestore(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'],
      recipientName: map['recipientName'],
      phoneNumber: map['phoneNumber'],
      houseNumber: map['houseNumber'],
      streetAddress: map['streetAddress'],
      landmark: map['landmark'] ?? '',
      city: map['city'],
      state: map['state'],
      postalCode: map['postalCode'],
      addressType: map['addressType'],
      isDefault: map['isDefault'],
      floor: map['floor'] ?? '',
      towerOrBlock: map['towerOrBlock'] ?? '',
    );
  }
}
