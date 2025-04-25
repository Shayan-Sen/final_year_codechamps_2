import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:final_year_codechamps_2/models/quiz.dart';
import 'package:final_year_codechamps_2/models/teacher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class TeacherServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Cloudinary _cloudinary = Cloudinary.basic(
    cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME']!,
  );

  Future<String> signUp({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String about,
    required String educationQualification,
    required FilePickerResult proofOfEd,
  }) async
  {
    try {
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
        'createdAt': response.createdAt,
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
      await _firestore
          .collection('teachers')
          .doc(userCredential.user!.uid)
          .set(teacher.toFirestore());
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
      DocumentSnapshot snapshot =
          await _firestore.collection('teachers').doc(cred.user!.uid).get();
      if (!snapshot.exists) {
        await _auth.signOut();
        return "User not found";
      }
      return "Logged in successfully";
    } catch (e) {
      return "Unable to login: $e";
    }
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
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection("teachers").doc(user.uid).get();
    Teacher teacher1 = Teacher.fromFirestore(snapshot, null);
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
        'createdAt': response.createdAt,
        'name': file.path.split('/').last,
        'extension': file.path.split('.').last,
        'publicId': response.publicId,
      };
      teacher1.proofOfEducation = proofOfEducation;
    }
    teacher1.name = (name == null) ? teacher1.name : name;
    teacher1.about = (about == null) ? teacher1.about : about;
    teacher1.educationQualification =
        (educationQualification == null)
            ? teacher1.educationQualification
            : educationQualification;
    await _firestore
        .collection("teachers")
        .doc(user.uid)
        .update(teacher1.toFirestore());
  }

  Future<void> updateProfilePicture({required XFile file}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not found");
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection("teachers").doc(user.uid).get();
    Teacher teacher1 = Teacher.fromFirestore(snapshot, null);
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
    teacher1.profileImage = profileImage;
    await _firestore.collection("teachers").doc(user.uid).update(teacher1.toFirestore());
  }

  Future<String> uploadQuiz({required Quiz quiz}) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not found");
    }

    final docRef = await _firestore
        .collection('teachers')
        .doc(user.uid)
        .collection('quizzes')
        .add(quiz.toFireStore());
    await docRef.update({'id': docRef.id});

    return "Quiz uploaded successfully";
  }

  Future<List<Quiz>> getQuizzes() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not found");
    QuerySnapshot querySnapshot =
        await _firestore
            .collection('teachers')
            .doc(user.uid)
            .collection('quizzes')
            .get();
    List<Quiz> quizzes =
        querySnapshot.docs
            .map(
              (doc) => Quiz.fromFireStore(
                doc as DocumentSnapshot<Map<String, dynamic>>,
                null,
              ),
            )
            .toList();
    return quizzes;
  }

  Future<String> deleteQuiz({required String quizId}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not found");
    await _firestore
        .collection("teachers")
        .doc(user.uid)
        .collection("quizzes")
        .doc(quizId)
        .delete();
    return "Quiz deleted successfully";
  }
}
