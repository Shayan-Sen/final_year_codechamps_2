import 'package:cloud_firestore/cloud_firestore.dart';

class Teacher {
  Teacher({
    required this.name,
    required this.email,
    required this.about,
    this.profileImage,
    required this.educationQualification,
    required this.proofOfEducation,
  });

  final String name;
  final String email;
  final String about;
  final String educationQualification;
  final Map<String, dynamic>? profileImage;
  final Map<String, dynamic> proofOfEducation;

  Teacher copyWith({
    String? name,
    String? about,
    String? educationQualification,
    Map<String, dynamic>? proofOfEducation,
    Map<String, dynamic>? profileImage,
  }) {
    return Teacher(
      name: name ?? this.name,
      email: email,
      about: about ?? this.about,
      educationQualification: educationQualification ?? this.educationQualification,
      profileImage: profileImage ?? this.profileImage,
      proofOfEducation: proofOfEducation ?? this.proofOfEducation,
    );
  }

  factory Teacher.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) throw Exception('Data not found');

    return Teacher(
      name: data['name'] as String,
      email: data['email'] as String,
      about: data['about'] as String,
      profileImage: data['profileImage'] as Map<String, dynamic>?,
      educationQualification: data['educationQualification'] as String,
      proofOfEducation: data['proofOfEducation'] as Map<String, dynamic>,
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
