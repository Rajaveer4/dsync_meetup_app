import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dsync_meetup_app/core/config/firebase_initializer.dart';

/// Ensures Firebase is initialized safely for widget/unit tests.
///
/// Uses a separate app name ("TEST") to avoid clashing with the main app.
/// This is essential in widget tests where the default app may already be initialized.
Future<void> ensureTestFirebaseInitialized() async {
  // Required for widget testing framework
  TestWidgetsFlutterBinding.ensureInitialized();

  // If TEST app already exists, return it
  if (Firebase.apps.any((app) => app.name == 'TEST')) return;

  try {
    // Initialize Firebase under the name 'TEST'
    await FirebaseInitializer.instance.init();
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
      // App already exists, safe to continue
      return;
    }
    // Any other error should be thrown
    rethrow;
  }
}

/// Cleans up all initialized Firebase apps after testing.
///
/// Call this in `tearDownAll()` to reset Firebase state and avoid leaks.
Future<void> cleanupTestFirebase() async {
  final apps = List<FirebaseApp>.from(Firebase.apps);
  for (final app in apps) {
    await app.delete();
  }

  // Reset any internal singleton state
  FirebaseInitializer.instance.reset();
}
