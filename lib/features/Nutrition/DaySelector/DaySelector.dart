import 'package:conquest/core/Controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/Controllers/Nutrition_Controller/nutrition_controller.dart';
import '../../../core/Controllers/Nutrition_Controller/water_intake_controller.dart';
import 'Widgets/DayCard.dart';

class DaySelector extends StatefulWidget {
  @override
  State<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  final ScrollController _scrollController = ScrollController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Queue the scroll to end for after the layout is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> getDaysList() {
    final user = UserController.instance.userModel.value;
    DateTime now = DateTime.now();
    // Set time to start of day for accurate comparisons
    DateTime today = DateTime(now.year, now.month, now.day);
    List<Map<String, dynamic>> days = [];

    // Get account creation date and set to start of day
    DateTime accountCreationDate = user!.accountCreationTime!;
    accountCreationDate = DateTime(accountCreationDate.year,
        accountCreationDate.month, accountCreationDate.day);

    // Calculate how many days ago the account was created
    int daysFromCreation = today.difference(accountCreationDate).inDays;

    // Calculate previous days limit
    int previousDays = 15;
    if (daysFromCreation < 15) {
      // If account is less than 15 days old, adjust previous days
      previousDays = daysFromCreation;
    }

    // Default future days is 3
    int futureDays = 3;

    // Calculate total available days (from account creation to current)
    int totalAvailableDays = previousDays + 1; // +1 for current day

    // If total available days plus future days is less than 6,
    // extend future days to meet minimum requirement
    if (totalAvailableDays + futureDays < 5) {
      futureDays = 5 - totalAvailableDays;
    }

    // Always start from account creation date
    DateTime startDate = accountCreationDate;
    // End date is always current date plus future days
    DateTime endDate = today.add(Duration(days: futureDays));
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate.add(const Duration(days: 1)))) {
      bool isToday = currentDate.isAtSameMomentAs(today);

      // A day is active if it's today or a future day
      bool isActive =
          currentDate.isAfter(today.subtract(const Duration(days: 1)));

      days.add({
        'day': DateFormat('E').format(currentDate),
        'date': DateFormat('d').format(currentDate),
        'fullDate': currentDate,
        'isActive': isActive,
        'isToday': isToday,
      });

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return days;
  }

  void _onDateSelected(DateTime date) async {
    setState(() {
      selectedDate = date;
    });

    final nutritionController = NutritionController.instance;
    final waterController = WaterIntakeController.instance;

    nutritionController.isLoading(true);
    waterController.isLoading(true);

    // Fetch meals and water intake for the selected date
    await nutritionController.fetchMeals(date: selectedDate);
    await waterController.fetchWaterIntake(date);

    nutritionController.isLoading(false);
    waterController.isLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    final days = getDaysList();

    return SizedBox(
      height: 80,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = selectedDate.isAtSameMomentAs(day['fullDate']);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: DayCard(
              day: day['day'],
              date: day['date'],
              isActive: day['isActive'],
              isToday: day['isToday'],
              isSelected: isSelected,
              onTap: () => _onDateSelected(day['fullDate']),
            ),
          );
        },
      ),
    );
  }
}
