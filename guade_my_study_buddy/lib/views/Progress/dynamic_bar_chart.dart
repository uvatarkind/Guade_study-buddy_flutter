import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Data structure to hold daily time spent
class DailyTimeData {
  final int dayIndex; // 0 for Mon, 1 for Tue, ... 6 for Sun
  final double timeSpent; // in hours

  DailyTimeData(this.dayIndex, this.timeSpent);
}

// Sample data simulating API response
//todo: the api data should be sorted before use
List<DailyTimeData> apiData = [
  DailyTimeData(0, 2), // Monday: 2 hours
  DailyTimeData(1, 0.5), // Tuestday: 0.5 hours
  DailyTimeData(2, 2.5), // Wednesday: 2.5 hours

  DailyTimeData(4, 4), // Friday: 4 hours
  DailyTimeData(6, 2), // Sunday: 2 hours
];

class DynamicBarChart extends StatelessWidget {
  const DynamicBarChart({Key? key}) : super(key: key);

  // Helper function to get the day name from the index
  String getDayName(int dayIndex) {
    switch (dayIndex) {
      case 0:
        return 'Mon';
      case 1:
        return 'Tue';
      case 2:
        return 'Wed';
      case 3:
        return 'Thu';
      case 4:
        return 'Fri';
      case 5:
        return 'Sat';
      case 6:
        return 'Sun';
      default:
        return '';
    }
  }

  // Helper function to create BarChartGroupData from DailyTimeData
  BarChartGroupData makeGroupData(DailyTimeData data) {
    return BarChartGroupData(
      x: data.dayIndex,
      barRods: [
        BarChartRodData(
          toY: data.timeSpent,
          color: Colors.deepPurple, // Customize bar color
          width: 16, // Customize bar width
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
      // Configure showing tooltip indicators to display values
      showingTooltipIndicators: [0], // Show tooltip for the first rod (index 0)
    );
  }

  @override
  Widget build(BuildContext context) {
    // Find the maximum time spent to set maxY for the chart
    final double maxY = apiData.map((data) => data.timeSpent).reduce(
              (a, b) => a > b ? a : b,
            ) +
        1; // Add some padding above the max value

    return AspectRatio(
      aspectRatio: 1.7, // Adjust aspect ratio as needed
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 18.0, right: 18.0, left: 6.0, bottom: 6.0),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY, // Set maxY based on data
              barTouchData: BarTouchData(
                enabled: true, // Enable touch data for tooltips
                touchTooltipData: BarTouchTooltipData(
                  // tooltipBgColor: Colors.blueGrey, // Tooltip background color
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    // Display the time spent value on top of the bar
                    return BarTooltipItem(
                      rod.toY.toStringAsFixed(
                          1), // Format the value (e.g., 2.0, 2.5)
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
                // Make tooltips always visible (optional, but shows values on top)
                // You might need to manage state to control visibility if you don't want them always on
                touchCallback:
                    (FlTouchEvent event, BarTouchResponse? response) {
                  // This callback is needed to make the tooltip show on hover/tap
                  // You can add more logic here if you need interactive behavior
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      // Get the corresponding DailyTimeData for the value (day index)
                      final data = apiData.firstWhere(
                        (d) => d.dayIndex == value.toInt(),
                        orElse: () => DailyTimeData(
                            -1, 0), // Provide a default if not found
                      );
                      if (data.dayIndex == -1)
                        return Container(); // Hide title if no data for the day

                      // Display the day name for the days with data
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 4,
                        child: Text(
                          getDayName(data.dayIndex),
                          style: const TextStyle(
                            color: Color(0xff7589a2),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      );
                    },
                    reservedSize: 20,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      // Display left axis titles (e.g., 0, 1, 2, ...)
                      if (value == 0) {
                        return Container(); // Hide 0
                      }
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: Color(0xff7589a2),
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: const FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
              ),
              borderData: FlBorderData(
                show: false,
              ),
              // Generate bar groups dynamically from the API data
              barGroups: apiData.map((data) => makeGroupData(data)).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
