import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:final_year_codechamps_2/models/student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class StudentServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Cloudinary _cloudinary = Cloudinary.basic(
    cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME']!,
  );

  final _studentCol = FirebaseFirestore.instance.collection('students').withConverter<Student>(
    fromFirestore: (snapshot, _) => Student.fromFirestore(snapshot),
    toFirestore: (student, _) => student.toFirestore(),
  );

  Future<Student> getStudent()async{
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not found");
    final student = (await _studentCol.doc(user.uid).get()).data()!;
    return student;
  }

  Future<String> signup({
    required String name,
    required String email,
    required String password,
    required String about,
  }) async
  {
    try {
      Student student = Student(name: name, email: email, about: about);
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _studentCol.doc(userCredential.user!.uid).set(student);
      return "Signed up successfully";
    } catch (e) {
      return "Unable to sign up: $e";
    }
  }

  Future<String> login({
    required String email,
    required String password,
}) async
  {
    try{
      final UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (cred.user == null) {
        await _auth.signOut();
        return "User not found";
      }
      final DocumentSnapshot snapshot =
          await _studentCol.doc(cred.user!.uid).get();
      if (!snapshot.exists) {
        await _auth.signOut();
        return "User not found";
        }else{
      return "Student Logged in successfully";}
    }
    catch (e) {
      return "Unable to login: $e";
    }
  }

  Future<void> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async
  {
    final AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("User not found");
    await currentUser.reauthenticateWithCredential(credential);
    await currentUser.delete();
    await _auth.signOut();
    Student student = (await _studentCol.doc(currentUser.uid).get()).data()!;
    if (student.profileImage != null) {
      String url = student.profileImage!['url'];
      await _cloudinary.deleteResource(url: url);
    }
    await _studentCol.doc(currentUser.uid).delete();
  }

  Future<void> updatePasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async
  {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("User not found");
    await currentUser.reauthenticateWithCredential(credential);
    await currentUser.updatePassword(newPassword);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> updateStudentDetails({
    String? name,
    String? about,
}) async
{
  final user = _auth.currentUser;
  if (user == null) throw Exception("User not found");
  Student student1 = (await _studentCol.doc(user.uid).get()).data()!;
  student1.copyWith(name: (name == null) ? student1.name : name);
  student1.copyWith(about: (about == null) ? student1.about : about);
  await _studentCol.doc(user.uid).set(student1);

}

  Future<void> updateProfilePicture({required XFile file}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not found");
    final Student student1 = (await _studentCol.doc(user.uid).get()).data()!;
    File file1 = File(file.path);
    Uint8List fileBytes = await file1.readAsBytes();
    CloudinaryResponse response = await _cloudinary.unsignedUploadResource(
      CloudinaryUploadResource(
        fileName: file1.path.split('/').last,
        fileBytes: fileBytes,
        uploadPreset: 'preset-for-file-upload',
        resourceType: CloudinaryResourceType.image,
      ),
    );
    if (student1.profileImage != null) {
      String url = student1.profileImage!['url'];
      await _cloudinary.deleteResource(url: url);
    }
    Map<String, dynamic> profileImage = {
      'url': response.secureUrl,
      'createdAt': response.createdAt,
      'name': file.path.split('/').last,
      'extension': file.path.split('.').last,
      'publicId': response.publicId,
      };
    student1.copyWith(profileImage: profileImage);
    await _studentCol
        .doc(user.uid)
        .update(student1.toFirestore());
  }

}
