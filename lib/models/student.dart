import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  Student({
    required this.name,
    required this.email,
    required this.about,
    this.teachers = const [],
    this.profileImage,
  });
  final String name;
  final String email;
  final String about;
  final Map<String, dynamic>? profileImage;
  final List<String> teachers;

  Student copyWith({
    String? name,
    String? about,
    Map<String, dynamic>? profileImage,
    List<String>? teachers,
  }) {
    return Student(
      name: name ?? this.name,
      email: email,
      about: about ?? this.about,
      profileImage: profileImage ?? this.profileImage,
      teachers: teachers ?? this.teachers,
    );
  }

  factory Student.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Student(
      name: data['name'] as String,
      email: data['email'] as String,
      about: data['about'] as String,
      profileImage: data['profileImage'] as Map<String, dynamic>?,
      teachers: List<String>.from(data['teachers'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'about': about,
      'profileImage': profileImage,
      'teachers': teachers,
    };
  }

  // Add JSON serialization methods for SharedPreferences caching

  // Convert Student object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'about': about,
      'profileImage': profileImage,
      'teachers': teachers,
    };
  }

  // Create a Student object from a JSON map
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'] as String,
      email: json['email'] as String,
      about: json['about'] as String,
      profileImage: json['profileImage'] != null
          ? Map<String, dynamic>.from(json['profileImage'])
          : null,
      teachers: json['teachers'] != null
          ? List<String>.from(json['teachers'])
          : [],
    );
  }
}