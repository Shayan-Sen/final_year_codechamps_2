import 'package:cloud_firestore/cloud_firestore.dart';

enum Roles { teacher, student }

class Users {
  Users({
    required this.name,
    required this.email,
    required this.role,
    required this.profileImage,
  });
  final String name;
  final String email;
  final Map<String,dynamic> profileImage;
  final Roles role;

  factory Users.fromFirestore(DocumentSnapshot<Map<String,dynamic>> snapshot) {
    final data = snapshot.data();
    return Users(
      name: data!['name'],
      email: data['email'],
      role: Roles.values.firstWhere((role) => role.name == data['role']),
      profileImage: data['profileImage'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'role': role.name,
      'profileImage': profileImage,
    };
  }
}
