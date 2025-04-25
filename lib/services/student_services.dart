import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StudentServices{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Cloudinary _cloudinary = Cloudinary.basic(
    cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME']!,
  );
}