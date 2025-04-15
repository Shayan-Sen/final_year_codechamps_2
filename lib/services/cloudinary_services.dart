import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryService{

  String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
  Future<bool> uploadToCloudinary(FilePickerResult? filePickerResult) async{
    return false;
  }

}
