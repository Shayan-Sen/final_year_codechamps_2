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
}
