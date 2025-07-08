import 'package:firebase_core/firebase_core.dart';
import '../../../firebase_options.dart';

class FirebaseInitializer {
  FirebaseInitializer._();

  static final FirebaseInitializer _instance = FirebaseInitializer._();
  static FirebaseInitializer get instance => _instance;

  Future<FirebaseApp>? _initialization;

  Future<FirebaseApp> init() {
    _initialization ??= _initializeFirebase();
    return _initialization!;
  }

  Future<FirebaseApp> _initializeFirebase() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        return Firebase.app();
      }

      return await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      if (e is FirebaseException && e.code == 'duplicate-app') {
        return Firebase.app();
      }
      rethrow;
    }
  }

  void reset() {
    _initialization = null;
  }

  static bool get isInitialized =>
      Firebase.apps.any((app) => app.name == defaultFirebaseAppName);
}
