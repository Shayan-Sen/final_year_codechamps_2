import 'package:cloud_firestore/cloud_firestore.dart';

enum Roles{teacher,student}

class Users{
  Users({required this.name,required this.email,required this.role,required this.profileImage});
  final String name;
  final String email;
  final DocumentSnapshot profileImage;
  final Roles role;
}