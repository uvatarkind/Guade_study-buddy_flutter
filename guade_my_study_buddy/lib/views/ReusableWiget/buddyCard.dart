import 'package:flutter/material.dart';

class Buddycard extends StatelessWidget {
  final String name;
  final String course;
  final String imagePath;
  final VoidCallback onTap;
  const Buddycard({
    super.key,
    required this.name,
    required this.course,
    required this.imagePath,
    required this.onTap,
  });

 @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 140,
        height: 180,
        child: Card(elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  imagePath,
                  height: 80,
                  width: double.infinity,
                  fit: BoxFit.cover,
        ),
      ),
    Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF7D1FB8), // Purple color
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}


