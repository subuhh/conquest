import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NutritionFactsChartWidget extends StatelessWidget {
  final Map<String, double> macros;

  const NutritionFactsChartWidget({super.key, required this.macros});

  @override
  Widget build(BuildContext context) {
    // Transform macros data into a list for Syncfusion PieChart
    final data = macros.entries.map((e) => _MacroData(e.key, e.value)).toList();

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Macronutrient Breakdown",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(fontWeightDelta: 2),
          ),
          const SizedBox(height: 16),
          SfCircularChart(
            legend: Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.scroll,
              position: LegendPosition.bottom,
            ),
            series: <PieSeries<_MacroData, String>>[
              PieSeries<_MacroData, String>(
                dataSource: data,
                xValueMapper: (data, _) => data.name,
                yValueMapper: (data, _) => data.value,
                dataLabelMapper: (data, _) =>
                    '${data.value.toStringAsFixed(1)}g',
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroData {
  final String name;
  final double value;

  _MacroData(this.name, this.value);
}

class NutritionFactsWidget extends StatelessWidget {
  final String servingSize;
  final double calories;
  final Map<String, dynamic> nutritionDetails;

  const NutritionFactsWidget({
    super.key,
    required this.servingSize,
    required this.calories,
    required this.nutritionDetails,
  });

  @override
  Widget build(BuildContext context) {
    final boldTextStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontWeight: FontWeight.bold);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text("Nutrition Facts",
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Divider(thickness: 1.5),
          const SizedBox(height: 8),
          Text("Serving Size", style: boldTextStyle),
          Text(servingSize, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          const Divider(thickness: 1.5),
          const SizedBox(height: 8),

          // Calories Section
          Text("Amount Per 100 Grams", style: boldTextStyle),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Calories",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                calories.toStringAsFixed(0),
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 1.5),
          const SizedBox(height: 8),

          // Nutrition Details Section
          ...nutritionDetails.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(entry.key,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  Text(
                    "${entry.value}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
