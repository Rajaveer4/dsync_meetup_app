import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsync_meetup_app/data/models/event_model.dart';

class MeetupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createEvent(String clubId, Event event) async {
    await _firestore
        .collection('clubs')
        .doc(clubId)
        .collection('events')
        .doc(event.id)
        .set(event.toMap());
  }

  Future<List<Event>> getEvents(String clubId) async {
    final snapshot = await _firestore
        .collection('clubs')
        .doc(clubId)
        .collection('events')
        .get();
        
    return snapshot.docs.map((doc) {
      return Event.fromMap({
        ...doc.data(),
        'id': doc.id,
      });
    }).toList();
  }

  Future<Event> getEventById(String clubId, String eventId) async {
    final doc = await _firestore
        .collection('clubs')
        .doc(clubId)
        .collection('events')
        .doc(eventId)
        .get();
        
    if (!doc.exists) {
      throw Exception('Event not found');
    }
    
    return Event.fromMap({
      ...doc.data()!,
      'id': doc.id,
    });
  }

  Future<void> updateEvent(String clubId, Event event) async {
    await _firestore
        .collection('clubs')
        .doc(clubId)
        .collection('events')
        .doc(event.id)
        .update(event.toMap());
  }

  Future<void> deleteEvent(String clubId, String eventId) async {
    await _firestore
        .collection('clubs')
        .doc(clubId)
        .collection('events')
        .doc(eventId)
        .delete();
  }

  // If you specifically need to update just the start time
  Future<void> updateEventStartTime(String clubId, String eventId, DateTime newStartTime) async {
    await _firestore
        .collection('clubs')
        .doc(clubId)
        .collection('events')
        .doc(eventId)
        .update({
          'startTime': newStartTime.toIso8601String(),
        });
  }

  // If you specifically need to update just the end time
  Future<void> updateEventEndTime(String clubId, String eventId, DateTime newEndTime) async {
    await _firestore
        .collection('clubs')
        .doc(clubId)
        .collection('events')
        .doc(eventId)
        .update({
          'endTime': newEndTime.toIso8601String(),
        });
  }
}