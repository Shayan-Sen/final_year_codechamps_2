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
    FilePickerResult? proofOfEd,
  }) async {
    try {
      File file = File(proofOfEd!.files.first.path!);
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

  Future<String> login(String email, String password) async {
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

  Future<void> uploadQuiz(Quiz quiz) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not found");
    }

    await _firestore
        .collection('teachers')
        .doc(user.uid)
        .collection('quizzes')
        .add(quiz.toFireStore());
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
}
