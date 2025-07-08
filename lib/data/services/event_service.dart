import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dsync_meetup_app/data/models/event_model.dart'; // Make sure this path is correct

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createEvent(String clubId, Event event) async {
    try {
      await _firestore
          .collection('clubs')
          .doc(clubId)
          .collection('events')
          .doc(event.id)
          .set({
            ...event.toMap(),
            'createdAt': FieldValue.serverTimestamp(),
            'createdBy': _auth.currentUser?.uid,
          });
    } on FirebaseException catch (e) {
      throw 'Failed to create event: ${e.message}';
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  Future<List<Event>> getEvents(String clubId) async {
    try {
      final snapshot = await _firestore
          .collection('clubs')
          .doc(clubId)
          .collection('events')
          .orderBy('startTime')
          .get();

      return snapshot.docs.map((doc) => Event.fromMap(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw 'Failed to load events: ${e.message}';
    }
  }

  Future<Event> getEventById(String clubId, String eventId) async {
    try {
      final doc = await _firestore
          .collection('clubs')
          .doc(clubId)
          .collection('events')
          .doc(eventId)
          .get();

      if (!doc.exists) throw 'Event not found';
      return Event.fromMap(doc.data()!);
    } on FirebaseException catch (e) {
      throw 'Failed to load event: ${e.message}';
    }
  }

  Future<void> updateEvent(String clubId, Event event) async {
    try {
      await _firestore
          .collection('clubs')
          .doc(clubId)
          .collection('events')
          .doc(event.id)
          .update({
            ...event.toMap(),
            'updatedAt': FieldValue.serverTimestamp(),
            'updatedBy': _auth.currentUser?.uid,
          });
    } on FirebaseException catch (e) {
      throw 'Failed to update event: ${e.message}';
    }
  }

  Future<void> deleteEvent(String clubId, String eventId) async {
    try {
      await _firestore
          .collection('clubs')
          .doc(clubId)
          .collection('events')
          .doc(eventId)
          .delete();
    } on FirebaseException catch (e) {
      throw 'Failed to delete event: ${e.message}';
    }
  }

  Future<void> rsvpToEvent(String clubId, String eventId, String userId) async {
    try {
      await _firestore
          .collection('clubs')
          .doc(clubId)
          .collection('events')
          .doc(eventId)
          .update({
            'participantIds': FieldValue.arrayUnion([userId]),
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } on FirebaseException catch (e) {
      throw 'Failed to RSVP: ${e.message}';
    }
  }

  Future<void> cancelRsvp(String clubId, String eventId, String userId) async {
    try {
      await _firestore
          .collection('clubs')
          .doc(clubId)
          .collection('events')
          .doc(eventId)
          .update({
            'participantIds': FieldValue.arrayRemove([userId]),
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } on FirebaseException catch (e) {
      throw 'Failed to cancel RSVP: ${e.message}';
    }
  }

  Future<List<Event>> getUpcomingEvents(String clubId) async {
    try {
      final snapshot = await _firestore
          .collection('clubs')
          .doc(clubId)
          .collection('events')
          .where('startTime', isGreaterThan: DateTime.now())
          .orderBy('startTime')
          .limit(10)
          .get();

      return snapshot.docs.map((doc) => Event.fromMap(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw 'Failed to load upcoming events: ${e.message}';
    }
  }

  Future<List<Event>> getUserEvents(String clubId, String userId) async {
    try {
      final snapshot = await _firestore
          .collection('clubs')
          .doc(clubId)
          .collection('events')
          .where('participantIds', arrayContains: userId)
          .orderBy('startTime')
          .get();

      return snapshot.docs.map((doc) => Event.fromMap(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw 'Failed to load user events: ${e.message}';
    }
  }
}