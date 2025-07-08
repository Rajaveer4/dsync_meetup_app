import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsync_meetup_app/data/models/user_model.dart';

class InteractionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logUserInteraction({
    required String userId,
    required String interactionType,
    required String targetId,
    String? targetType,
  }) async {
    await _firestore.collection('user_interactions').add({
      'userId': userId,
      'interactionType': interactionType,
      'targetId': targetId,
      'targetType': targetType,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<List<User>> getSuggestedConnections(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .where('id', isNotEqualTo: userId)
        .limit(10)
        .get();

    return snapshot.docs
        .map((doc) => User.fromJson(doc.data()))
        .toList();
  }

  Future<void> followUser(String followerId, String followingId) async {
    final batch = _firestore.batch();

    // Add to follower's following list
    final followerRef = _firestore.collection('users').doc(followerId);
    batch.update(followerRef, {
      'following': FieldValue.arrayUnion([followingId])
    });

    // Add to following user's followers list
    final followingRef = _firestore.collection('users').doc(followingId);
    batch.update(followingRef, {
      'followers': FieldValue.arrayUnion([followerId])
    });

    await batch.commit();
  }
}