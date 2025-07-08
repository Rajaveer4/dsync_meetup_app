# Firebase Configuration

## FirebaseInitializer

The `FirebaseInitializer` class provides a singleton pattern for safely initializing Firebase in your Flutter application. It prevents duplicate initialization errors that can occur during hot-reload, widget tests, or when running multiple isolates.

### Features

- **One-time initialization**: Ensures Firebase is initialized only once, no matter how many times `init()` is called
- **Safe for hot-reload**: Won't throw duplicate initialization errors during development
- **Test-friendly**: Includes a `reset()` method for testing scenarios
- **Thread-safe**: Handles concurrent initialization attempts correctly
- **Automatic detection**: Detects if Firebase is already initialized and returns the existing app

### Usage

#### Basic Usage

```dart
import 'package:dsync_meetup_app/core/config/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await FirebaseInitializer.init();
  
  runApp(MyApp());
}
```

#### In Services or Other Classes

```dart
class AuthService {
  Future<void> signIn() async {
    // Ensure Firebase is initialized before using Firebase services
    await FirebaseInitializer.init();
    
    // Now safe to use Firebase Auth
    await FirebaseAuth.instance.signInAnonymously();
  }
}
```

#### In Widget Tests

```dart
void main() {
  setUp(() {
    // Reset Firebase state before each test
    FirebaseInitializer.reset();
  });
  
  testWidgets('should initialize Firebase', (tester) async {
    await FirebaseInitializer.init();
    expect(FirebaseInitializer.isInitialized, isTrue);
  });
}
```

### API Reference

#### `FirebaseInitializer.init()`

Initializes Firebase and returns a `Future<FirebaseApp>`. This method:
- Can be called multiple times safely
- Always returns the same future for concurrent calls
- Detects existing Firebase apps and returns them instead of reinitializing

#### `FirebaseInitializer.isInitialized`

A getter that returns `true` if Firebase has been initialized, `false` otherwise.

#### `FirebaseInitializer.reset()`

⚠️ **For testing only!** Resets the internal initialization state. This should only be used in test scenarios.

### Benefits

1. **Prevents "Firebase has already been initialized" errors**
2. **Simplifies Firebase setup across the app**
3. **Makes testing easier with the reset functionality**
4. **Handles edge cases like hot-reload automatically**
5. **Provides a clean, predictable API**

### Implementation Details

The class uses a static `Future<FirebaseApp>?` field to cache the initialization promise. When `init()` is called:

1. If the future already exists, it returns the cached future
2. If not, it checks if Firebase is already initialized using `Firebase.apps.any((app) => app.name == defaultFirebaseAppName)`
3. If already initialized, it returns the existing app
4. Otherwise, it calls `Firebase.initializeApp()` with the platform-specific options

This approach ensures that Firebase initialization happens exactly once, regardless of how many times or from how many places `init()` is called.

