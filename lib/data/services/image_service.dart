import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  Future<String> uploadImage(File image, String path) async {
    try {
      final String fileName = '${_uuid.v4()}.jpg';
      final Reference ref = _storage.ref('$path/$fileName');
      final UploadTask uploadTask = ref.putFile(image);
      final TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  Future<List<String>> uploadMultipleImages(List<File> images, String path) async {
    try {
      final List<String> urls = [];
      for (final image in images) {
        final url = await uploadImage(image, path);
        urls.add(url);
      }
      return urls;
    } catch (e) {
      throw Exception('Multiple image upload failed: $e');
    }
  }
}