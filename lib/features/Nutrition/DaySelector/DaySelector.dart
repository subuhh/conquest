// import 'package:flutter/material.dart';
//
// import 'Widgets/DayCard.dart';
//
// class DaySelector extends StatelessWidget {
//   final List<Map<String, dynamic>> days = [
//     {'day': 'Fri', 'date': '13', 'isActive': true},
//     {'day': 'Sat', 'date': '14', 'isActive': true},
//     {'day': 'Sun', 'date': '15', 'isActive': true},
//     {'day': 'Mon', 'date': '16', 'isActive': true, 'isToday': true},
//     {'day': 'Tue', 'date': '17', 'isActive': false},
//     {'day': 'Wed', 'date': '18', 'isActive': false},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 80, // Adjust the height as needed
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal, // Horizontal scrolling
//         itemCount: days.length,
//         itemBuilder: (context, index) {
//           final day = days[index];
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//             child: DayCard(
//               day: day['day'],
//               date: day['date'],
//               isActive: day['isActive'],
//               isToday: day['isToday'] ?? false, // Default isToday to false
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Widgets/DayCard.dart';

class DaySelector extends StatelessWidget {
  // Helper function to generate the list of days
  List<Map<String, dynamic>> getDaysList() {
    DateTime now = DateTime.now();
    List<Map<String, dynamic>> days = [];

    // Calculate the days (2 before and 3 after the current day)
    for (int i = -2; i <= 3; i++) {
      DateTime day = now.add(Duration(days: i));
      bool isToday = i == 0; // Mark today
      bool isActive = day
          .isAfter(now.subtract(Duration(days: 1))); // Active if within range

      days.add({
        'day': DateFormat('E')
            .format(day), // Format to abbreviated day (e.g., 'Mon')
        'date': DateFormat('d').format(day), // Format to day of the month
        'isActive': !isActive,
        'isToday': isToday,
      });
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final days = getDaysList(); // Get the list of days based on current date

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
