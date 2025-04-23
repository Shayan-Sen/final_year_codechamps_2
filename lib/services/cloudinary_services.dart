import 'dart:io';
import 'dart:typed_data';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryService {
  Cloudinary cloudinary = Cloudinary.basic(
    cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME']!,
  );
  Future<bool> uploadImageToCloudinary(FilePickerResult? filePickerResult) async {
    if (filePickerResult != null) {
      return false;
    }
    File file = File(filePickerResult!.files.first.path!);
    Uint8List fileBytes = file.readAsBytesSync();
    CloudinaryResponse response = await cloudinary.unsignedUploadResource(
      CloudinaryUploadResource(
        filePath: file.path,
        fileName: file.path.split('/').last,
        resourceType: CloudinaryResourceType.image,
        fileBytes: fileBytes,
        uploadPreset: 'preset-for-file-upload',
      ),
    );

    print(response);
    return true;
  }
}
