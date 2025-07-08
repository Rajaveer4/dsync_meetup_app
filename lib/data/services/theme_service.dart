// lib/data/services/theme_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ThemeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userDoc = 'userThemes';

  Future<bool> getDarkMode(String userId) async {
    final doc = await _firestore.collection(_userDoc).doc(userId).get();
    if (!doc.exists) return false;
    return doc.data()?['darkMode'] as bool? ?? false;
  }

  Future<void> setDarkMode(String userId, bool isDark) async {
    await _firestore.collection(_userDoc).doc(userId).set({
      'darkMode': isDark,
      'updatedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }
}
