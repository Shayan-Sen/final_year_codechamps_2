import 'package:cloud_firestore/cloud_firestore.dart';

class Teacher {

  Teacher({
    required this.name,
    required this.email,
    required this.about,
    this.profileImage,
    required this.educationQualification,
    required this.proofOfEducation});

  final String name;
  final String email;
  final String about;
  final String educationQualification;
  final Map<String, dynamic>? profileImage;
  final Map<String, dynamic> proofOfEducation;

  factory Teacher.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,SnapshotOptions? options) {
    final data = snapshot.data();
    if (data == null) throw Exception('Data not found');

    return Teacher(
      name: data['name'],
      email: data['email'],
      about: data['about'],
      profileImage: data['profileImage'],
      educationQualification: data['educationQualification'],
      proofOfEducation: data['proofOfEducation'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'about': about,
      'educationQualification': educationQualification,
      'profileImage': profileImage,
      'proofOfEducation': proofOfEducation,
    };
  }
}