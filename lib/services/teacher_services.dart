import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:final_year_codechamps_2/models/quiz.dart';
import 'package:final_year_codechamps_2/models/teacher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class TeacherServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Cloudinary _cloudinary = Cloudinary.basic(
    cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME']!,
  );

  final _teacherCol = FirebaseFirestore.instance
      .collection('teachers')
      .withConverter<Teacher>(
        fromFirestore: (snapshot, _) => Teacher.fromFirestore(snapshot),
        toFirestore: (teacher, _) => teacher.toFirestore(),
      );

  Future<Teacher> getTeacher() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not found");
    return (await _teacherCol.doc(user.uid).get()).data()!;
  }

  Future<String> signUp({
    required String name,
    required String email,
    required String password,
    required String about,
    required String educationQualification,
    required FilePickerResult proofOfEd,
  }) async
  {
    try {
      print(_cloudinary.cloudName);
      File file = File(proofOfEd.files.first.path!);
      Uint8List fileBytes = await file.readAsBytes();
      CloudinaryResponse response = await _cloudinary.unsignedUploadResource(
        CloudinaryUploadResource(
          uploadPreset: 'preset-for-file-upload',
          resourceType: CloudinaryResourceType.raw,
          fileName: file.path.split('/').last,
          fileBytes: fileBytes,
        ),
      );
      Map<String, dynamic> proofOfEducation = {
        'url': response.secureUrl,
        'createdAt': response.createdAt.toString(),
        'name': file.path.split('/').last,
        'extension': file.path.split('.').last,
        'publicId': response.publicId,
      };
      Teacher teacher = Teacher(
        name: name,
        email: email,
        about: about,
        educationQualification: educationQualification,
        proofOfEducation: proofOfEducation,
      );
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _teacherCol.doc(userCredential.user!.uid).set(teacher);
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
    try {
      final UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (cred.user == null) {
        await _auth.signOut();
        return "User not found";
      }
      final DocumentSnapshot snapshot =
          await _teacherCol.doc(cred.user!.uid).get();
      if (!snapshot.exists) {
        await _auth.signOut();
        return "User not found";
      }
      return "Logged in successfully";
    } catch (e) {
      return "Unable to login: $e";
    }
  }

  Future<void> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> deleteAccount({
    required String username,
    required String password,
  }) async
  {
    AuthCredential credential = EmailAuthProvider.credential(
      email: username,
      password: password,
    );
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("User not found");
    await currentUser.reauthenticateWithCredential(credential);
    await currentUser.delete();
    await _auth.signOut();
    Teacher teacher = (await _teacherCol.doc(currentUser.uid).get()).data()!;
    String url = teacher.proofOfEducation['url'];
    await _cloudinary.deleteResource(url: url);
    if (teacher.profileImage != null) {
      String url = teacher.profileImage!['url'];
      await _cloudinary.deleteResource(url: url);
    }
    await _teacherCol.doc(currentUser.uid).delete();
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

  Future<void> updateTeacherDetails({
    String? name,
    String? about,
    String? educationQualification,
    FilePickerResult? proofOfEd,
  }) async
  {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not found");

    Teacher teacher1 = (await _teacherCol.doc(user.uid).get()).data()!;
    if (proofOfEd != null) {
      File file = File(proofOfEd.files.first.path!);
      Uint8List fileBytes = await file.readAsBytes();
      CloudinaryResponse response = await _cloudinary.unsignedUploadResource(
        CloudinaryUploadResource(
          fileBytes: fileBytes,
          fileName: file.path.split("/").last,
          uploadPreset: "preset-for-file-upload",
          resourceType: CloudinaryResourceType.raw,
        ),
      );
      String url = teacher1.proofOfEducation['url'];
      await _cloudinary.deleteResource(url: url);

      Map<String, dynamic> proofOfEducation = {
        'url': response.secureUrl,
        'createdAt': response.createdAt.toString(),
        'name': file.path.split('/').last,
        'extension': file.path.split('.').last,
        'publicId': response.publicId,
      };
      teacher1.copyWith(proofOfEducation: proofOfEducation);
    }
    teacher1.copyWith(
      name: (name == null) ? teacher1.name : name,
      about: (about == null) ? teacher1.about : about,
      educationQualification:
          (educationQualification == null)
              ? teacher1.educationQualification
              : educationQualification,
    );
    await _teacherCol.doc(user.uid).set(teacher1);
  }

  Future<void> updateProfilePicture({required XFile file}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not found");

    Teacher teacher1 = (await _teacherCol.doc(user.uid).get()).data()!;
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
    if (teacher1.profileImage != null) {
      String url = teacher1.profileImage!['url'];
      await _cloudinary.deleteResource(url: url);
    }

    Map<String, dynamic> profileImage = {
      'url': response.secureUrl,
      'createdAt': response.createdAt,
      'name': file.path.split('/').last,
      'extension': file.path.split('.').last,
      'publicId': response.publicId,
    };
    teacher1.copyWith(profileImage: profileImage);
    await _teacherCol.doc(user.uid).update(teacher1.toFirestore());
  }

  Future<String> uploadQuiz({required Quiz quiz}) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not found");
    }

    final docRef = await _teacherCol
        .doc(user.uid)
        .collection('quizzes')
        .add(quiz.toFirestore());
    await docRef.update({'id': docRef.id});

    return "Quiz uploaded successfully";
  }

  Future<List<Quiz>> getQuizzes() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not found");
    QuerySnapshot querySnapshot =
        await _teacherCol.doc(user.uid).collection('quizzes').get();
    List<Quiz> quizzes =
        querySnapshot.docs
            .map(
              (doc) => Quiz.fromFireStore(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              ),
            )
            .toList();
    return quizzes;
  }

  Future<String> deleteQuiz({required String quizId}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not found");
    await _teacherCol
        .doc(user.uid)
        .collection("quizzes")
        .doc(quizId)
        .delete();
    return "Quiz deleted successfully";
  }
}
