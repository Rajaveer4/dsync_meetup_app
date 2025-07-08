import 'package:firebase_core/firebase_core.dart'; // Add this
import 'package:firebase_auth/firebase_auth.dart'; // Also needed if handling auth-specific errors

class ErrorHandler {
  static String handleError(dynamic error) {
    if (error is String) {
      return error;
    } else if (error is FirebaseException) {
      return error.message ?? 'Firebase error occurred';
    } else {
      return 'An unexpected error occurred';
    }
  }
}
