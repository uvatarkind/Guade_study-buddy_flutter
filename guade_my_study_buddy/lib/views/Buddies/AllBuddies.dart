import 'package:flutter/material.dart';
import './BuddyDetailScreen.dart';

class AllBuddiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(10),
      children: List.generate(6, (index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => BuddyDetailScreen()));
          },
          child: Card(
            elevation: 4,
            child: Column(
              children: [
                Expanded(
                    child: Image.asset('assets/images/buddy1.jpg',
                        fit: BoxFit.cover)),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("SUPER NOVA",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text("Maths, Physics, Astronomy",
                    style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        );
      }),
    );
  }
}
