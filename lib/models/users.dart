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
  final String profileImage;
  final Roles role;
}
