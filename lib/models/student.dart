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
  List<String> teachers;

  factory Student.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,SnapshotOptions? options) {
    final data = snapshot.data();
    if (data == null) throw Exception("Data not found");

    return Student(
      name: data['name'],
      email: data['email'],
      about: data['about'],
      profileImage: data['profileImage'],
      teachers: data['teachers'],
    );
  }

  Map<String,dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'about': about,
      'profileImage': profileImage,
      'teachers': teachers,
    };
  }
}
