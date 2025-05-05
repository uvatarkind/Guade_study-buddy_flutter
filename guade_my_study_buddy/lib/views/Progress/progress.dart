import 'package:flutter/material.dart';
import 'package:guade_my_study_buddy/services/api_service.dart';
import './dynamic_bar_chart.dart'; // Ensure this path is correct
import 'package:table_calendar/table_calendar.dart';
// import 'package:fl_chart/fl_chart.dart'; // fl_chart is now used inside DynamicBarChart
import 'package:intl/intl.dart'; // Required for getting the day of the week

// Assuming you have an API service to fetch data
// import 'package:your_app/services/api_service.dart'; // Uncomment and update path

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Progress',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
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
  Set<DateTime> _activeDays = {}; // Initialize as empty

  // State variables for data fetching
  bool _isLoading = true;
  String? _errorMessage; // To store any error message

  // This list will hold all active days fetched from the API (full year until today)
  // Using List<DateTime> might be easier to process than a Set for weekly data
  List<DateTime> _allActiveDaysList = [];
  Map<DateTime, double> _allActiveDaysListWithDuration = {};

  @override
  void initState() {
    super.initState();
    _fetchActiveDays(); // Start fetching data when the widget is created
  }

  // Function to simulate fetching active days from an API
  Future<void> _fetchActiveDays() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // --- Replace with your actual API call ---
      // Example: Fetch dates from the start of the year up to today
      final DateTime now = DateTime.now();
      final DateTime startOfYear = DateTime.utc(now.year, 1, 1);

      // Simulate an API call returning a list of DateTime objects
      await Future.delayed(Duration(seconds: 2)); // Simulate network delay

      List<dynamic> fromJson = await HoursService().getHoursSpent();
      Map<DateTime, double> filteredDateMap = {
        for (var data in fromJson)
          DateTime.utc(
            DateTime.parse(data['date']).year,
            DateTime.parse(data['date']).month,
            DateTime.parse(data['date']).day,
          ): data['hoursSpent']
      };

// Apply filtering based on date range
      filteredDateMap = Map.fromEntries(filteredDateMap.entries.where((entry) =>
          entry.key.isBefore(now.add(Duration(days: 1))) &&
          entry.key.isAfter(startOfYear.subtract(Duration(days: 1)))));

      setState(() {
        _allActiveDaysListWithDuration = filteredDateMap;
        _activeDays =
            filteredDateMap.keys.toSet(); // Update the set for the calendar
        _isLoading = false;
      });
    } catch (e) {
      // Handle errors
      setState(() {
        _errorMessage = 'Failed to load progress data: ${e.toString()}';
        _isLoading = false;
      });
      print('Error fetching active days: $e'); // Log error
    }
  }

  // Function to get events for a specific day (used by table_calendar)
  List<String> _getEventsForDay(DateTime day) {
    // table_calendar provides local dates, convert to UTC midnight for comparison
    final utcDay = DateTime.utc(day.year, day.month, day.day);
    // Check if the UTC day is in our set of active days
    if (_activeDays.contains(utcDay)) {
      return ['Active']; // Return a non-empty list to mark the day
    }
    return []; // Return an empty list for inactive days
  }

  // Function to get the start date of the current week (Monday)
  DateTime _getStartOfCurrentWeek(DateTime date) {
    // ISO 8601 week starts on Monday (1) and ends on Sunday (7)
    int weekday = date.weekday; // 1 = Monday, 7 = Sunday
    return date.subtract(Duration(days: weekday - 1));
  }

  // Function to prepare data for the weekly bar chart
  List<DailyTimeData> _getWeeklyActiveData() {
    if (_allActiveDaysListWithDuration.isEmpty) {
      return []; // Return empty list if no data fetched
    }

    final DateTime now = DateTime.now();
    final DateTime startOfCurrentWeek = _getStartOfCurrentWeek(DateTime.utc(
        now.year,
        now.month,
        now.day)); // Get start of the current week (UTC midnight)

    // Create a map to store the count of active days for each day of the week
    // Key: dayIndex (0-6), Value: count
    final Map<int, double> weeklyCounts = {};
    for (int i = 0; i < 7; i++) {
      weeklyCounts[i] = 0; // Initialize counts for all 7 days
    }

    // Iterate through all fetched active days and count those within the current week
    for (final activeDay in _allActiveDaysListWithDuration.keys) {
      // Ensure activeDay is also treated as UTC midnight for comparison
      final DateTime activeDayUtc =
          DateTime.utc(activeDay.year, activeDay.month, activeDay.day);
      print('each_active day-> $activeDayUtc');

      // Check if the active day is within the current week (inclusive)
      if (activeDayUtc
              .isAfter(startOfCurrentWeek.subtract(Duration(days: 1))) &&
          activeDayUtc.isBefore(startOfCurrentWeek.add(Duration(days: 7)))) {
        // Calculate the day index (0 for Mon, 6 for Sun)
        // DateTime.weekday gives 1 for Mon, 7 for Sun. Subtract 1.
        final int dayIndex = activeDayUtc.weekday - 1;
        weeklyCounts[dayIndex] =
            (_allActiveDaysListWithDuration[activeDay] ?? 0); // Increment count
      }
    }

    // Convert the map to a list of DailyTimeData for the chart
    final List<DailyTimeData> weeklyData = [];
    for (int i = 0; i < 7; i++) {
      weeklyData.add(DailyTimeData(
          i, weeklyCounts[i]!.toDouble())); // Use count as the value
    }

    return weeklyData;
  }

  // Helper function to calculate streak (Optional - you can refine this logic)
  int _calculateCurrentStreak() {
    if (_activeDays.isEmpty) {
      return 0;
    }

    int streak = 0;
    DateTime currentDate = DateTime.utc(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day); // Start from today (UTC midnight)

    // Check if today was active
    if (_activeDays.contains(currentDate)) {
      streak = 1;
      currentDate =
          currentDate.subtract(Duration(days: 1)); // Move to yesterday
    } else {
      // If today is not active, check if yesterday was active
      DateTime yesterday = currentDate.subtract(Duration(days: 1));
      if (!_activeDays.contains(yesterday)) {
        return 0; // No streak if neither today nor yesterday was active
      }
      // If yesterday was active but today wasn't, the streak ended yesterday.
      // We can calculate the streak ending yesterday, but the "current" streak starting today is 0.
      // However, often "current streak" counts today if active, or the streak *ending* yesterday if today is the first break.
      // Let's calculate the streak ending *on or before* today.
    }

    // Go back day by day and count consecutive active days
    while (_activeDays.contains(currentDate)) {
      streak++;
      currentDate = currentDate.subtract(Duration(days: 1));
    }

    // Edge case: If today wasn't active, the calculated streak includes yesterday and before.
    // If today was active, it starts from today. The loop logic handles this.
    // The initial check correctly handles whether today is part of the streak.
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    // Prepare weekly data for the chart
    final List<DailyTimeData> weeklyChartData = _getWeeklyActiveData();
    final int currentStreak =
        _calculateCurrentStreak(); // Calculate the current streak

    return Scaffold(
      appBar: AppBar(
        title: Text('My Progress'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : _errorMessage != null
              ? Center(
                  // Show error message
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error: $_errorMessage',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  // Show content if not loading and no error
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
                            eventLoader:
                                _getEventsForDay, // Use eventLoader to highlight active days
                            calendarStyle: CalendarStyle(
                              // Style the active days
                              markerDecoration: const BoxDecoration(
                                color: Colors
                                    .deepPurpleAccent, // Color for active days
                                shape: BoxShape.circle,
                              ),
                              todayDecoration: BoxDecoration(
                                color: Colors.deepPurple
                                    .withOpacity(0.5), // Style for today
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: BoxDecoration(
                                color:
                                    Colors.deepPurple, // Style for selected day
                                shape: BoxShape.circle,
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible:
                                  false, // Hide the format button
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
                              Icon(Icons.local_fire_department,
                                  size: 40, color: Colors.deepPurple),
                              SizedBox(
                                  width: 16), // Space between icon and text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Current Streak is $currentStreak days', // Use calculated streak
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    // You might add text related to longest streak here if available
                                    currentStreak > 0
                                        ? Text(
                                            'Study hard Play hard!', // Generic message or replace with longest streak data
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          )
                                        : Text(
                                            'Keep up the great work!', // Generic message or replace with longest streak data
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
                        'Weekly Report (Active Days Count)', // Updated title
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          // Provide the weekly data to the DynamicBarChart
                          child: DynamicBarChart(weeklyData: weeklyChartData),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  // Removed unused fl_chart helper functions: makeGroupData, getBottomTitles, getLeftTitles
  // These are now handled inside DynamicBarChart
}
