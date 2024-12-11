class Report {
  final String reportId;
  final String reportedUserId;
  final String reportByUserId;
  final String reportType;
  final String? description;
  final DateTime createdAt;

  Report({
    required this.reportId,
    required this.reportedUserId,
    required this.reportByUserId,
    required this.reportType,
    this.description,
    required this.createdAt,
  });

  // Convert Report to JSON for easy storage in Firestore
  Map<String, dynamic> toMap() {
    return {
      'reportId': reportId,
      'reportedUserId': reportedUserId,
      'reportByUserId': reportByUserId,
      'reportType': reportType,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create a Report object from a Map (for reading from Firestore)
  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      reportId: map['reportId'],
      reportedUserId: map['reportedUserId'],
      reportByUserId: map['reportByUserId'],
      reportType: map['reportType'],
      description: map['description'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
