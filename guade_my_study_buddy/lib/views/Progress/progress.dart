import 'package:flutter/material.dart';
import './dynamic_bar_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart'; 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Progress',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Progress(),
    );
  }
}

class Progress extends StatefulWidget {
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // This set will hold the dates the user was active, fetched from your API.
  // For demonstration, I'm using a few sample dates.
  Set<DateTime> _activeDays = {
    DateTime.utc(2023, 1, 2),
    DateTime.utc(2023, 1, 3),
    DateTime.utc(2023, 1, 4),
    DateTime.utc(2023, 1, 5),
    DateTime.utc(2023, 1, 6),
    // Add more dates fetched from your API here
  };

  // Function to get events for a specific day (used by table_calendar)
  List<String> _getEventsForDay(DateTime day) {
    // Check if the day is in our set of active days
    if (_activeDays.contains(DateTime.utc(day.year, day.month, day.day))) {
      return ['Active']; // Return a non-empty list to mark the day
    }
    return []; // Return an empty list for inactive days
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Progress'),
        centerTitle: true,
        // todo: if neccessary uncomment it, since the scaffold will handle the placment of the back button already.
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     // TODO: Implement navigation back
        //   },
        // ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Calendar Section
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    // Use `selectedDayPredicate` to determine which day is currently selected.
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    }
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  eventLoader: _getEventsForDay, // Use eventLoader to highlight active days
                  calendarStyle: CalendarStyle(
                    // Style the active days
                    markerDecoration: const BoxDecoration(
                      color: Colors.purple, // Color for active days
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                       color: Colors.purple.withOpacity(0.5), // Style for today
                       shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.purpleAccent, // Style for selected day
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false, // Hide the format button
                    titleCentered: true,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Current Streak Card
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.purple[50], // Light purple background
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    // Placeholder for SVG Fire Icon
                    Container(
                      width: 50, // Adjust size as needed
                      height: 50, // Adjust size as needed
                      // You will replace this Container with your SvgPicture.asset or SvgPicture.network
                      // Example:
                      // SvgPicture.asset(
                      //   'assets/fire_icon.svg', // Path to your SVG file
                      //   width: 50,
                      //   height: 50,
                      //   color: Colors.purple, // Optional: color the SVG
                      // ),
                      decoration: BoxDecoration(
                        color: Colors.transparent, // Placeholder background
                        // You might add a border or other styling if needed for the placeholder
                      ),
                      // Optional: Add a temporary icon or text to the placeholder
                       child: Icon(Icons.local_fire_department, size: 40, color: Colors.purple),
                    ),
                    SizedBox(width: 16), // Space between icon and text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Current Streak is 5 days', // Replace with actual streak data
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'This is the longest you have ever had!', // Replace with actual data
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Weekly Report (Bar Graph)
            Text(
              'Weekly Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Expanded(
                  // height: 200, // Set a height for the graph
                  child: DynamicBarChart()
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to create bar groups
  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.purple, // Color of the bars
          width: 16, // Width of the bars
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  // Widget to get bottom titles (Days of the week)
  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Mon', style: style);
        break;
      case 1:
        text = const Text('Tue', style: style);
        break;
      case 2:
        text = const Text('Wed', style: style);
        break;
      case 3:
        text = const Text('Thu', style: style);
        break;
      case 4:
        text = const Text('Fri', style: style);
        break;
      case 5:
        text = const Text('Sat', style: style);
        break;
      case 6:
        text = const Text('Sun', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4.0,
      child: text,
    );
  }

  // Widget to get left titles (Y-axis values)
  Widget getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value % 1 == 0) { // Show whole numbers on the y-axis
       text = value.toInt().toString();
    }
     else {
      return Container(); // Hide non-integer values
    }
    return Text(text, style: style, textAlign: TextAlign.center);
  }
}
