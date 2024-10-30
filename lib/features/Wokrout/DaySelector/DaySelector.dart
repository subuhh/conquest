import 'package:flutter/material.dart';

import 'Widgets/DayCard.dart';

class DaySelector extends StatelessWidget {
  final List<Map<String, dynamic>> days = [
    {'day': 'Fri', 'date': '13', 'isActive': true},
    {'day': 'Sat', 'date': '14', 'isActive': true},
    {'day': 'Sun', 'date': '15', 'isActive': true},
    {'day': 'Mon', 'date': '16', 'isActive': true, 'isToday': true},
    {'day': 'Tue', 'date': '17', 'isActive': false},
    {'day': 'Wed', 'date': '18', 'isActive': false},
    {'day': 'Thu', 'date': '19', 'isActive': false},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80, // Adjust the height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Horizontal scrolling
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: DayCard(
              day: day['day'],
              date: day['date'],
              isActive: day['isActive'],
              isToday: day['isToday'] ?? false, // Default isToday to false
            ),
          );
        },
      ),
    );
  }
}

