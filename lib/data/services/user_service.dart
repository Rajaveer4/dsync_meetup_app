import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:dsync_meetup_app/data/models/user_model.dart' as app_model;

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  // Get current user from Firebase Auth
  firebase_auth.User? get currentFirebaseUser => _auth.currentUser;

  // Get current user data as our User model
  Future<app_model.User?> getCurrentUser() async {
    final firebaseUser = currentFirebaseUser;
    if (firebaseUser == null) return null;
    return getUser(firebaseUser.uid);
  }

  // Get user by ID
  Future<app_model.User?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) return null;
    return app_model.User.fromFirestore(doc);
  }

  // Create or update user
  Future<void> saveUser(app_model.User user) async {
    await _firestore.collection('users').doc(user.id).set(
      user.toJson(),
      SetOptions(merge: true),
    );
  }

  // Update user profile
  Future<void> updateProfile({
    required String userId,
    String? name,
    String? username,
    String? bio,
    String? photoURL,
  }) async {
    final updateData = <String, dynamic>{};
    
    if (name != null) updateData['name'] = name;
    if (username != null) updateData['username'] = username;
    if (bio != null) updateData['bio'] = bio;
    if (photoURL != null) updateData['photoURL'] = photoURL;
    
    updateData['updatedAt'] = Timestamp.now();

    await _firestore.collection('users').doc(userId).update(updateData);
  }

  // Update user interests
  Future<void> updateInterests(String userId, List<String> interests) async {
    await _firestore.collection('users').doc(userId).update({
      'interests': interests,
      'updatedAt': Timestamp.now(),
    });
  }

  // Search users by name or username
  Future<List<app_model.User>> searchUsers(String query) async {
    if (query.isEmpty) return [];
    
    final nameResults = await _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: '$query\uf8ff')
        .limit(10)
        .get();

    final usernameResults = await _firestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThan: '$query\uf8ff')
        .limit(10)
        .get();

    final users = [
      ...nameResults.docs.map((doc) => app_model.User.fromFirestore(doc)),
      ...usernameResults.docs.map((doc) => app_model.User.fromFirestore(doc)),
    ];

    // Remove duplicates
    return users.toSet().toList();
  }
}