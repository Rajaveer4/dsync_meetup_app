import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Auth related methods
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // User data methods
  Future<DocumentSnapshot> getUserData(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  Future<void> saveUserData(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  // Event methods
  Future<List<Event>> getRecommendedEvents(List<String> interests) async {
    if (interests.isEmpty) return getAllEvents();
    
    final query = await _firestore
        .collection('events')
        .where('category', whereIn: interests)
        .orderBy('dateTime')
        .limit(10)
        .get();
    
    return query.docs.map((doc) => Event.fromFirestore(doc)).toList();
  }

  Future<List<Event>> getAllEvents() async {
    final query = await _firestore
        .collection('events')
        .orderBy('dateTime')
        .limit(10)
        .get();
    return query.docs.map((doc) => Event.fromFirestore(doc)).toList();
  }

  Future<void> addEvent(Event event) async {
    await _firestore.collection('events').add(event.toMap());
  }

  // Event registration
  Future<void> registerForEvent(String userId, String eventId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('registered_events')
        .doc(eventId)
        .set({'registeredAt': FieldValue.serverTimestamp()});

    await _firestore
        .collection('events')
        .doc(eventId)
        .collection('attendees')
        .doc(userId)
        .set({'registeredAt': FieldValue.serverTimestamp()});
  }

  Future<List<Event>> getUserRegisteredEvents(String userId) async {
    final query = await _firestore
        .collection('users')
        .doc(userId)
        .collection('registered_events')
        .get();

    if (query.docs.isEmpty) return [];

    final eventIds = query.docs.map((doc) => doc.id).toList();
    final eventsQuery = await _firestore
        .collection('events')
        .where(FieldPath.documentId, whereIn: eventIds)
        .get();

    return eventsQuery.docs.map((doc) => Event.fromFirestore(doc)).toList();
  }
}