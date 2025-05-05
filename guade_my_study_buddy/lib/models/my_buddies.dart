/// A data model representing a Buddy Group.
class BuddyGroup {
  final String name;
  final String subjects;
  final String image;
  final String description;

  /// Constructor for the BuddyGroup class.
  BuddyGroup({
    required this.name,
    required this.subjects,
    required this.image,
    required this.description,
  });

  /// Factory constructor to create a BuddyGroup instance from a JSON map.
  /// This is used for decoding JSON.
  factory BuddyGroup.fromJson(Map<String, dynamic> json) {
    return BuddyGroup(
      name: json['name'] as String,
      subjects: json['subjects'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
    );
  }

  /// Method to convert a BuddyGroup instance into a JSON map.
  /// This is used for encoding to JSON.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'subjects': subjects,
      'image': image,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'BuddyGroup(name: $name, subjects: $subjects, image: $image, description: $description)';
  }
}