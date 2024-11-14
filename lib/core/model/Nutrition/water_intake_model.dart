import 'package:cloud_firestore/cloud_firestore.dart';

class WaterIntakeModel {
  final DateTime date;
  double totalIntake; // in milliliters
  final List<WaterEntry> entries; // List to store each intake entry

  WaterIntakeModel({
    required this.date,
    required this.totalIntake,
    required this.entries,
  });

  // Method to convert model to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'totalIntake': totalIntake,
      'entries': entries.map((entry) => entry.toMap()).toList(),
    };
  }

  // Method to create a model from a Firestore document
  factory WaterIntakeModel.fromMap(Map<String, dynamic> map) {
    return WaterIntakeModel(
      date: (map['date'] as Timestamp).toDate(),
      totalIntake: map['totalIntake']?.toDouble() ?? 0.0,
      entries: (map['entries'] as List)
          .map((entry) => WaterEntry.fromMap(entry))
          .toList(),
    );
  }
}

class WaterEntry {
  final DateTime time;
  final double amount; // in milliliters

  WaterEntry({
    required this.time,
    required this.amount,
  });

  // Method to convert entry to a map
  Map<String, dynamic> toMap() {
    return {
      'time': Timestamp.fromDate(time),
      'amount': amount,
    };
  }

  // Method to create entry from a map
  factory WaterEntry.fromMap(Map<String, dynamic> map) {
    return WaterEntry(
      time: (map['time'] as Timestamp).toDate(),
      amount: map['amount']?.toDouble() ?? 0.0,
    );
  }
}
