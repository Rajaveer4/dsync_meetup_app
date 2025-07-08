import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dsync_meetup_app/core/config/firebase_initializer.dart';
import '../../../test_helpers/firebase_test_helper.dart';

void main() {
  group('FirebaseInitializer Tests', () {
    // Initialize Firebase for all tests in this suite
    setUpAll(() async {
      await ensureTestFirebaseInitialized();
    });
    
    // Clean up after all tests in this suite
    tearDownAll(() async {
      await cleanupTestFirebase();
    });
    
    test('should be a singleton', () {
      final instance1 = FirebaseInitializer.instance;
      final instance2 = FirebaseInitializer.instance;
      
      expect(instance1, same(instance2));
    });
    
    test('should indicate Firebase is initialized after setup', () {
      expect(FirebaseInitializer.isInitialized, isTrue);
    });
    
    test('should have TEST app available', () {
      final testApp = Firebase.apps.firstWhere(
        (app) => app.name == 'TEST',
        orElse: () => throw StateError('TEST app not found'),
      );
      
      expect(testApp.name, equals('TEST'));
    });
  });
}

