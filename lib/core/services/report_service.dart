import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../model/report.dart'; // For generating unique reportId

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a report
  Future<void> addReport(
      {required String reportedUserId,
      required String reportType,
      String? description,
      required String reportByUserId}) async {
    try {
      String reportId = Uuid().v4(); // Unique report ID
      Report report = Report(
        reportId: reportId,
        reportedUserId: reportedUserId,
        reportByUserId: reportByUserId,
        reportType: reportType,
        description: description,
        createdAt: DateTime.now(),
      );

      // Save the report to Firestore (assuming 'reports' collection)
      await _firestore.collection('reports').doc(reportId).set(report.toMap());
      print('Report submitted successfully!');
    } catch (e) {
      log('Error submitting report: $e');
      // throw Exception('Failed to submit report');
    }
  }
}
