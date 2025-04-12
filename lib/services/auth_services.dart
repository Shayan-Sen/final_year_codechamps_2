import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  Future<UserCredential> signUp(String email, String password) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
