import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class EducationCard extends StatefulWidget {
  /// The Cloudinary-stored proofOfEducation map:
  /// {
  ///   'url': 'https://...',
  ///   'name': 'degree.pdf',
  ///   // ...
  /// }
  final Map<String, dynamic> proofOfEducation;

  const EducationCard({required this.proofOfEducation, super.key});

  @override
  State<EducationCard> createState() => _EducationCardState();
}

class _EducationCardState extends State<EducationCard> {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _snack(String message){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _downloadFile(BuildContext context) async {
    final url  = widget.proofOfEducation['url'] as String;
    final name = widget.proofOfEducation['name'] as String;

    // 1) Ask storage permission (Android)
    if (await Permission.storage.request().isDenied) {
      _snack('Storage permission denied');
      return;
    }

    // 2) Get downloads directory
    Directory? downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
    } else {
      downloadsDir = await getApplicationDocumentsDirectory();
    }
    final savePath = '${downloadsDir.path}/$name';

    // 3) Download with Dio
    try {
      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (rec, total) {
          final progress = (rec / total * 100).toStringAsFixed(0);
          _snack('Downloading: $progress%');
        },
      );
      _snack('Saved to $savePath');
    } catch (e) {
      _snack('Download failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.proofOfEducation['name'] as String? ?? 'Document';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.file_download, size: 32),
        title: Text('Proof of Education'),
        subtitle: Text(fileName),
        trailing: IconButton(
          icon: const Icon(Icons.download_rounded),
          onPressed: () => _downloadFile(context),
        ),
      ),
    );
  }
}
