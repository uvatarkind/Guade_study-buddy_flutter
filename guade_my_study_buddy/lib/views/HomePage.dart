import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ReusableWiget/buddyCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _username = "User"; // Default value

  @override
  void initState() {
    super.initState();
    _loadUsername(); // ✅ Load username when home page starts
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            _buildHeader(context),

            const SizedBox(height: 20),

            // Greeting section
            _buildGreetingSection(textTheme),

            const SizedBox(height: 16),

            // Upcoming session card
            _buildUpcomingSessionCard(primaryColor),

            const SizedBox(height: 24),

            // Popular buddies section header
            _buildSectionHeader(
              title: 'Popular Buddies',
              onSeeMoreTap: () {
                debugPrint('Navigate to see all buddies');
              },
              textTheme: textTheme,
              primaryColor: primaryColor,
            ),

            const SizedBox(height: 12),

            // Buddies horizontal list
            _buildBuddiesListView(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // logo
        CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(
            'assets/images/logo.jpg',
          ),
        ),
        // Notification icon
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {
            // Show notification modal
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Your Work',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Text('You have no new notifications.'),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGreetingSection(TextTheme textTheme) {
    return Text(
      'Good day $_username!', // ✅ Display the retrieved username
      style: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  Widget _buildUpcomingSessionCard(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/clock.png',
            height: 40,
            width: 40,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Upcoming session in an hour',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () {
              debugPrint('Navigate to session details');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onSeeMoreTap,
    required TextTheme textTheme,
    required Color primaryColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        GestureDetector(
          onTap: onSeeMoreTap,
          child: Text(
            'See more',
            style: textTheme.bodyMedium?.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBuddiesListView() {
    final buddies = [
      {
        'name': 'SUPER NOVA',
        'course': 'Maths, Physics, Astronomy',
        'imagePath': 'assets/images/buddy1.jpg',
      },
      {
        'name': 'MATH WIZARD',
        'course': 'Calculus, Algebra, Statistics',
        'imagePath': 'assets/images/buddy2.jpg',
      },
      {
        'name': 'CODE MASTER',
        'course': 'Programming, Algorithms, Data Structures',
        'imagePath': 'assets/images/buddy3.jpg',
      },
    ];

    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: buddies.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final buddy = buddies[index];
          return Buddycard(
            name: buddy['name'] ?? '',
            course: buddy['course'] ?? '',
            imagePath: buddy['imagePath'] ?? '',
            onTap: () {
              debugPrint('Navigate to ${buddy['name']} details');
            },
          );
        },
      ),
    );
  }
}
