import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:dsync_meetup_app/data/models/club_model.dart';
import 'package:dsync_meetup_app/data/models/user_model.dart' as app_user;

class ClubService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final String _collection = 'clubs';

  String get _currentUserId => _auth.currentUser?.uid ?? '';

  Future<List<ClubModel>> getClubs() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs
        .map((doc) => ClubModel.fromMap(doc.data()))
        .toList();
  }

  Future<List<ClubModel>> getMyClubs() async {
    final snapshot = await _firestore.collection(_collection)
        .where('members', arrayContains: _currentUserId)
        .get();
    return snapshot.docs
        .map((doc) => ClubModel.fromMap(doc.data()))
        .toList();
  }

  Future<void> createClub(ClubModel club) async {
    await _firestore
        .collection(_collection)
        .doc(club.id)
        .set(club.toMap());
  }

  Future<ClubModel> getClubDetails(String clubId) async {
    final doc = await _firestore.collection(_collection).doc(clubId).get();
    if (!doc.exists) {
      throw Exception('Club not found');
    }
    return ClubModel.fromMap(doc.data()!);
  }

  Future<List<app_user.User>> getClubMembers(String clubId) async {
    final membersSnapshot = await _firestore
        .collection(_collection)
        .doc(clubId)
        .collection('members')
        .get();
    
    final users = await Future.wait(
      membersSnapshot.docs.map((doc) async {
        final userDoc = await _firestore.collection('users').doc(doc.id).get();
        if (!userDoc.exists) {
          throw Exception('User ${doc.id} not found');
        }
        return app_user.User.fromJson(userDoc.data()!);
      }),
    );
    
    return users;
  }

  Future<void> addMember(String clubId, String userId) async {
    final batch = _firestore.batch();
    final clubRef = _firestore.collection(_collection).doc(clubId);
    
    batch.update(clubRef, {
      'members': FieldValue.arrayUnion([userId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    batch.set(
      clubRef.collection('members').doc(userId),
      {
        'joinedAt': FieldValue.serverTimestamp(),
        'role': 'member',
        'userId': userId,
      },
    );
    
    await batch.commit();
  }

  Future<void> removeMember(String clubId, String userId) async {
    final batch = _firestore.batch();
    final clubRef = _firestore.collection(_collection).doc(clubId);
    
    batch.update(clubRef, {
      'members': FieldValue.arrayRemove([userId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    batch.delete(clubRef.collection('members').doc(userId));
    
    await batch.commit();
  }

  Future<void> joinClub(String clubId) async {
    await addMember(clubId, _currentUserId);
  }

  Future<void> updateClubDetails(String clubId, ClubModel updatedClub) async {
    await _firestore
        .collection(_collection)
        .doc(clubId)
        .update({
          ...updatedClub.toMap(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
  }
}