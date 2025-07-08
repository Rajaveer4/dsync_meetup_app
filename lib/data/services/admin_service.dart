import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsync_meetup_app/data/models/event_model.dart';
import 'package:dsync_meetup_app/data/models/user_model.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<User>> getAllUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => User.fromJson(doc.data())).toList();
  }

  Future<List<Event>> getAllEvents() async {
    final snapshot = await _firestore.collection('events').get();
    return snapshot.docs.map((doc) => Event.fromMap(doc.data())).toList();
  }

  Future<void> disableUser(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'isActive': false,
      'disabledAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> enableUser(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'isActive': true,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
  }

  Future<Map<String, dynamic>> getAppStatistics() async {
    final usersCount = await _firestore.collection('users').count().get();
    final activeUsersCount = await _firestore.collection('users')
        .where('isActive', isEqualTo: true)
        .count()
        .get();
    final eventsCount = await _firestore.collection('events').count().get();
    
    return {
      'totalUsers': usersCount.count,
      'activeUsers': activeUsersCount.count,
      'totalEvents': eventsCount.count,
    };
  }
}