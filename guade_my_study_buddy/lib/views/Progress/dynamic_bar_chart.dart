import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Data structure to hold daily time spent (representing hours)
class DailyTimeData {
  final int dayIndex; // 0 for Mon, 1 for Tue, ... 6 for Sun
  final double timeSpent; // in hours

  DailyTimeData(this.dayIndex, this.timeSpent);
}

class DynamicBarChart extends StatelessWidget {
  // Accept the data list via constructor
  final List<DailyTimeData> weeklyData;

  const DynamicBarChart({Key? key, required this.weeklyData}) : super(key: key);

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
          toY: data.timeSpent, // Use 'timeSpent' from DailyTimeData
          color: Colors.deepPurple, // Customize bar color
          width: 16, // Customize bar width
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
      // Configure showing tooltip indicators to display values
      // Only show tooltip if the value is greater than 0
      showingTooltipIndicators: data.timeSpent > 0 ? [0] : [],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Find the maximum time spent to set maxY for the chart
    // Ensure maxY is at least 1 if all values are 0
    final double maxY = weeklyData.isEmpty
        ? 1.0
        : (weeklyData.map((data) => data.timeSpent).reduce(
              (a, b) => a > b ? a : b,
            )).ceilToDouble() + 1; // Find max value, round up, add padding


    // Create bar groups for all 7 days, even if the timeSpent is 0
    // This ensures all weekdays are shown on the axis.
    final List<BarChartGroupData> allWeeklyGroups = List.generate(7, (index) {
        // Find the data for this day index, or use a default with timeSpent 0
        final DailyTimeData dataForDay = weeklyData.firstWhere(
            (d) => d.dayIndex == index,
            orElse: () => DailyTimeData(index, 0.0), // Default to 0 hours
        );
        return makeGroupData(dataForDay);
    });


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
                   tooltipRoundedRadius: 8.0, // This property is still valid
                   tooltipMargin: 8.0, // This property is still valid
                   // tooltipBgColor and arrowLength are removed
                   getTooltipItem: (group, groupIndex, rod, rodIndex) {
                     // Display the value as hours with one decimal place if needed
                     if (rod.toY <= 0) return null; // Hide tooltip for 0 values

                      String tooltipText;
                      if (rod.toY == rod.toY.toInt()) { // If it's a whole number
                          tooltipText = '${rod.toY.toInt()}h';
                      } else { // Otherwise, show one decimal place
                          tooltipText = '${rod.toY.toStringAsFixed(1)}h';
                      }

                     return BarTooltipItem(
                       tooltipText,
                       const TextStyle(
                         color: Colors.white,
                         fontWeight: FontWeight.bold,
                         fontSize: 12,
                       ),
                       // Apply the background color using decoration here
                      //  decoration: BoxDecoration(
                      //    color: Colors.deepPurple.withOpacity(0.7),
                      //    borderRadius: BorderRadius.circular(4),
                      //  ),
                     );
                   },
                ),
                 touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
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
                      // Display the day name for all 7 day indices
                      final int dayIndex = value.toInt();
                       if (dayIndex >= 0 && dayIndex < 7) {
                         return SideTitleWidget(
                           axisSide: meta.axisSide,
                           space: 4,
                           child: Text(
                             getDayName(dayIndex),
                             style: const TextStyle(
                               color: Color(0xff7589a2),
                               fontWeight: FontWeight.bold,
                               fontSize: 10,
                             ),
                           ),
                         );
                       }
                       return Container(); // Hide title if not a valid day index
                    },
                    reservedSize: 20,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      // Display left axis titles (e.g., 0h, 1h, 2h, ...)
                      if (value == 0) {
                         return Text(
                            '0h',
                             style: const TextStyle(
                                color: Color(0xff7589a2),
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                             ),
                             textAlign: TextAlign.center,
                         );
                       } else if (value % 1 == 0 && value <= maxY) { // Show whole numbers up to max
                         return Text(
                            '${value.toInt()}h',
                             style: const TextStyle(
                                color: Color(0xff7589a2),
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                             ),
                             textAlign: TextAlign.center,
                         );
                       }
                      return Container(); // Hide intermediate and outside values
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
                horizontalInterval: 1, // Show grid lines at integer values (hours)
                // Optional: customize grid line color/style if needed
                // getDrawingHorizontalLine: (value) => const FlLine(
                //   color: Color(0xffe0e0e0),
                //   strokeWidth: 0.5,
                // ),
                 // drawVerticalLine: false, // Already set above
              ),
              borderData: FlBorderData(
                show: false, // Hide default border
                 // Optional: Add custom borders if needed
                 // border: Border.all(color: const Color(0xff393939), width: 1),
              ),
              // Use the generated list of bar groups for all 7 days
              barGroups: allWeeklyGroups,
            ),
          ),
        ),
      ),
    );
  }
}