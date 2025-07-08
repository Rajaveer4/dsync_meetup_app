// lib/data/services/announcement_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsync_meetup_app/data/models/announcement_model.dart';

class AnnouncementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AnnouncementModel>> getAnnouncements(String clubId) async {
    try {
      final snapshot = await _firestore
          .collection('announcements')
          .where('clubId', isEqualTo: clubId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => AnnouncementModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to load announcements: $e');
    }
  }

  Future<void> createAnnouncement(AnnouncementModel announcement) async {
    try {
      await _firestore
          .collection('announcements')
          .doc(announcement.id)
          .set(announcement.toMap());
    } catch (e) {
      throw Exception('Failed to create announcement: $e');
    }
  }
}