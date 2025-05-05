import 'package:flutter/material.dart';
import './BuddyDetailScreen.dart';

class AllBuddiesScreen extends StatelessWidget {
  final String searchQuery;

  AllBuddiesScreen({required this.searchQuery});

  final List<Map<String, String>> buddies = [
    {
      "name": "SUPER NOVA",
      "subjects": "Maths, Physics, Astronomy",
      "image": "assets/images/buddy1.jpg"
    },
    {
      "name": "MATH MASTERS",
      "subjects": "Maths, Calculus, Algebra",
      "image": "assets/images/buddy2.jpg"
    },
    {
      "name": "ASTRO CLUB",
      "subjects": "Physics, Space Science",
      "image": "assets/images/buddy3.jpg"
    },
    {
      "name": "LOGIC LEGENDS",
      "subjects": "Maths, Logic, AI",
      "image": "assets/images/buddy4.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredBuddies = buddies.where((buddy) {
      final name = buddy['name']!.toLowerCase();
      final subjects = buddy['subjects']!.toLowerCase();
      final query = searchQuery.toLowerCase();
      return name.contains(query) || subjects.contains(query);
    }).toList();

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      padding: EdgeInsets.all(10),
      children: List.generate(filteredBuddies.length, (index) {
        final buddy = filteredBuddies[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BuddyDetailScreen()),
            );
          },
          child: Card(
            elevation: 6,
            shadowColor: Colors.deepPurpleAccent,
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(buddy['image']!, fit: BoxFit.cover),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    buddy['name']!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ),
                Text(
                  buddy['subjects']!,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 9),
              ],
            ),
          ),
        );
      }),
    );
  }
}
