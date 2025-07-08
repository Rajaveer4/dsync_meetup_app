import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for Windows.');
      case TargetPlatform.linux:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for Linux.');
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB-LfEhYr4PhQd-yejAfybgy2oJ4lC_apY',
    appId: '1:762462508542:web:3ce78ff72266fa710ddcaf',
    messagingSenderId: '762462508542',
    projectId: 'dsync-meetup-app',
    authDomain: 'dsync-meetup-app.firebaseapp.com',
    storageBucket: 'dsync-meetup-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB-LfEhYr4PhQd-yejAfybgy2oJ4lC_apY',
    appId: '1:762462508542:android:d63bb50ed25ddf0a0ddcaf',
    messagingSenderId: '762462508542',
    projectId: 'dsync-meetup-app',
    storageBucket: 'dsync-meetup-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-LfEhYr4PhQd-yejAfybgy2oJ4lC_apY',
    appId: '1:762462508542:ios:5513ed4f6e55ac160ddcaf',
    messagingSenderId: '762462508542',
    projectId: 'dsync-meetup-app',
    storageBucket: 'dsync-meetup-app.appspot.com',
    iosBundleId: 'com.example.dsyncMeetupApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB-LfEhYr4PhQd-yejAfybgy2oJ4lC_apY',
    appId: '1:762462508542:macos:5513ed4f6e55ac160ddcaf',
    messagingSenderId: '762462508542',
    projectId: 'dsync-meetup-app',
    storageBucket: 'dsync-meetup-app.appspot.com',
    iosBundleId: 'com.example.dsyncMeetupApp',
  );
}
