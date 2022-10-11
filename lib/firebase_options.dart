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
    apiKey: 'AIzaSyA_LquOH_4XokhYz5tilbOIvupyfPQyezQ',
    appId: '1:412032399318:web:ff763073730f7718ed9677',
    messagingSenderId: '412032399318',
    projectId: 'lautan-luas-bulk',
    authDomain: 'lautan-luas-bulk.firebaseapp.com',
    storageBucket: 'lautan-luas-bulk.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAMixk3QTq0aphhXcrYimlf2bFgEGjR4Ko',
    appId: '1:412032399318:android:36a0a4f7e6d49fbaed9677',
    messagingSenderId: '412032399318',
    projectId: 'lautan-luas-bulk',
    storageBucket: 'lautan-luas-bulk.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB3apvyR6iAA42IMDLVcAOwaoUi4LIyW3E',
    appId: '1:412032399318:ios:23309742290fe00ced9677',
    messagingSenderId: '412032399318',
    projectId: 'lautan-luas-bulk',
    storageBucket: 'lautan-luas-bulk.appspot.com',
    iosClientId: '412032399318-1r11m91347reqaggvsit204pqqgh4vo8.apps.googleusercontent.com',
    iosBundleId: 'com.example.ltlBulk',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB3apvyR6iAA42IMDLVcAOwaoUi4LIyW3E',
    appId: '1:412032399318:ios:23309742290fe00ced9677',
    messagingSenderId: '412032399318',
    projectId: 'lautan-luas-bulk',
    storageBucket: 'lautan-luas-bulk.appspot.com',
    iosClientId: '412032399318-1r11m91347reqaggvsit204pqqgh4vo8.apps.googleusercontent.com',
    iosBundleId: 'com.example.ltlBulk',
  );
}