import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChanges => _auth.authStateChanges().asyncMap((user) {
    if (user == null) return null;
    return getUserProfile(user.uid);
  });

  Future<User?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return getUserProfile(user.uid);
  }

  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google Sign-In aborted');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final firebase_auth.User user = userCredential.user!;
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        final newUser = User(
          id: user.uid,
          name: user.displayName ?? 'No Name',
          email: user.email ?? '',
          photoURL: user.photoURL, 
          provider: 'google',
          isActive: true,
          createdAt: DateTime.now(),
        );
        await _firestore.collection('users').doc(user.uid).set(newUser.toJson());
        return newUser;
      }
      return User.fromJson(userDoc.data()!);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getUserProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) throw Exception('User not found');
    return User.fromJson(doc.data()!);
  }

  Future<void> updateUserProfile(User user) async {
    await _firestore.collection('users').doc(user.id).update({
      ...user.toJson(),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw Exception('No authenticated user found');
    }

    final credential = firebase_auth.EmailAuthProvider.credential(
      email: user.email!,
      password: oldPassword,
    );

    try {
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Password change failed');
    }
  }

  Future<bool> isEmailVerified() async {
    final firebaseUser = _auth.currentUser;
    return firebaseUser?.emailVerified ?? false;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    // TODO: Implement password reset logic, e.g., call your backend or Firebase
    // Example:
    // await firebaseAuth.sendPasswordResetEmail(email: email);
    throw UnimplementedError('sendPasswordResetEmail is not implemented');
  }
}
