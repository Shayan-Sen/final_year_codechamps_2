import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? get currentUser => auth.currentUser;
  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<UserCredential> createAccount({required String email,required String password})async{
    return await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signIn({required String email,required String password})async{
    return await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut()async{
    await auth.signOut();
  }

  Future<void> resetPassword({required String email})async{
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername({required String username})async{
    if(currentUser!=null){
      await currentUser!.updateDisplayName(username);
    }
  }
}
