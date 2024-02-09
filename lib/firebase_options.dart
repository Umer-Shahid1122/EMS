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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCh46gD3-EihPVqTEpoR4FP2pgMFbC09DM',
    appId: '1:318145853793:web:31fcb6c544c4c89f626d20',
    messagingSenderId: '318145853793',
    projectId: 'umer-ems',
    authDomain: 'umer-ems.firebaseapp.com',
    storageBucket: 'umer-ems.appspot.com',
    measurementId: 'G-Z4G9X904DP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCwN-9WK_RhkZVN_FGHO7mF6_pDAd1mzGw',
    appId: '1:318145853793:android:5a603b185a30b372626d20',
    messagingSenderId: '318145853793',
    projectId: 'umer-ems',
    storageBucket: 'umer-ems.appspot.com',
  );
}