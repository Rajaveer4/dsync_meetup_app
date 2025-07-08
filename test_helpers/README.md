# Test Helpers

This directory contains utility functions and helpers for testing.

## Firebase Test Helper

### `ensureTestFirebaseInitialized()`

A safe Firebase initialization helper for tests that:

- Ensures `TestWidgetsFlutterBinding` is initialized
- Creates a Firebase app named 'TEST' for testing purposes
- Handles cases where Firebase is already initialized
- Avoids conflicts with the default Firebase app used in production

### Usage

Call this helper in every test suite's `setUpAll` method:

```dart
import '../test_helpers/firebase_test_helper.dart';

void main() {
  group('My Test Suite', () {
    setUpAll(() async {
      await ensureTestFirebaseInitialized();
    });
    
    // Optional: Clean up after tests
    tearDownAll(() async {
      await cleanupTestFirebase();
    });
    
    test('my test', () {
      // Your test code here
    });
  });
}
```

### `cleanupTestFirebase()`

Optional cleanup helper that:

- Deletes all Firebase apps to ensure clean state
- Resets the `FirebaseInitializer` instance
- Should be called in `tearDownAll()` if you need a clean state between test suites

### Key Features

1. **Safe Re-initialization**: Can be called multiple times without errors
2. **Isolated Testing**: Uses a separate 'TEST' app to avoid conflicts
3. **Proper Cleanup**: Provides utilities to clean up Firebase state after tests
4. **Error Handling**: Gracefully handles duplicate app initialization attempts

