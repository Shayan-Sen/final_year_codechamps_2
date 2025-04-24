import 'dart:io';
import 'dart:typed_data';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  Cloudinary cloudinary = Cloudinary.basic(
    cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME']!,
  );
  Future<CloudinaryResponse?> uploadFileToCloudinary(FilePickerResult? filePickerResult) async {
    if (filePickerResult != null) {
      return null;
    }
    File file = File(filePickerResult!.files.first.path!);
    Uint8List fileBytes = file.readAsBytesSync();
    CloudinaryResponse response = await cloudinary.unsignedUploadResource(
      CloudinaryUploadResource(
        filePath: file.path,
        fileName: file.path.split('/').last,
        resourceType: CloudinaryResourceType.raw,
        fileBytes: fileBytes,
        uploadPreset: 'preset-for-file-upload',
      ),
    );
    print(response);
    return response;
  }

  Future<CloudinaryResponse?> uploadImageToCloudinary(XFile? imageFile) async {
    if (imageFile == null) {
      return null;
    }
    File file = File(imageFile.path);
    Uint8List fileBytes = file.readAsBytesSync();
    CloudinaryResponse response = await cloudinary.unsignedUploadResource(
      CloudinaryUploadResource(
        filePath: file.path,
        fileName: file.path.split('/').last,
        resourceType: CloudinaryResourceType.image,
        fileBytes: fileBytes,
        uploadPreset: 'preset-for-file-upload',
      ));
    print(response);
    return response;
  }
}
