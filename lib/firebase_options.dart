// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBhfhD5DsdHDShMDZXdKMubpxq34amr0O4',
    appId: '1:812292840106:web:57ee7125c32801dda20ed3',
    messagingSenderId: '812292840106',
    projectId: 'exterior-6fe1a',
    authDomain: 'exterior-6fe1a.firebaseapp.com',
    storageBucket: 'exterior-6fe1a.appspot.com',
    measurementId: 'G-VRLH9KL259',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyClfIOHgSHTkZAiEifthuoIKHY-zHZGrZw',
    appId: '1:812292840106:android:db58153a78b75220a20ed3',
    messagingSenderId: '812292840106',
    projectId: 'exterior-6fe1a',
    storageBucket: 'exterior-6fe1a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAn6ZoGeC6gHnNKUwQM6_LlSRLXHc55xX8',
    appId: '1:812292840106:ios:76b9a5b386c424f2a20ed3',
    messagingSenderId: '812292840106',
    projectId: 'exterior-6fe1a',
    storageBucket: 'exterior-6fe1a.appspot.com',
    iosBundleId: 'com.example.exterior',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAn6ZoGeC6gHnNKUwQM6_LlSRLXHc55xX8',
    appId: '1:812292840106:ios:7fd835f680e59600a20ed3',
    messagingSenderId: '812292840106',
    projectId: 'exterior-6fe1a',
    storageBucket: 'exterior-6fe1a.appspot.com',
    iosBundleId: 'com.example.exterior.RunnerTests',
  );
}