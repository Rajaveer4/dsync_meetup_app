import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfileImage(XFile imageFile, String userId) async {
    final ref = _storage.ref().child('profile_images/$userId');
    await ref.putData(await imageFile.readAsBytes());
    return await ref.getDownloadURL();
  }

  Future<String> uploadEventImage(XFile imageFile, String eventId) async {
    final ref = _storage.ref().child('event_images/$eventId');
    await ref.putData(await imageFile.readAsBytes());
    return await ref.getDownloadURL();
  }
}