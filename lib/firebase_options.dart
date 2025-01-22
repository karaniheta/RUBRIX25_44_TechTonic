// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyAc1tqTnppUOdLhFvg5-BrjX2i8mRytIuY',
    appId: '1:135805289633:web:679884326e59b73cab9ce0',
    messagingSenderId: '135805289633',
    projectId: 'anvaya-e628f',
    authDomain: 'anvaya-e628f.firebaseapp.com',
    storageBucket: 'anvaya-e628f.firebasestorage.app',
    measurementId: 'G-ZF6FTB340F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBS8C3z7aSrfndujVtTZkU4eCh-K854z20',
    appId: '1:135805289633:android:f58286da820a80a2ab9ce0',
    messagingSenderId: '135805289633',
    projectId: 'anvaya-e628f',
    storageBucket: 'anvaya-e628f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC_oy11s76ImpSoM4mCA3EYLPZsgRnD92g',
    appId: '1:135805289633:ios:7460d3cf48779abcab9ce0',
    messagingSenderId: '135805289633',
    projectId: 'anvaya-e628f',
    storageBucket: 'anvaya-e628f.firebasestorage.app',
    iosBundleId: 'com.example.anvaya',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC_oy11s76ImpSoM4mCA3EYLPZsgRnD92g',
    appId: '1:135805289633:ios:7460d3cf48779abcab9ce0',
    messagingSenderId: '135805289633',
    projectId: 'anvaya-e628f',
    storageBucket: 'anvaya-e628f.firebasestorage.app',
    iosBundleId: 'com.example.anvaya',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAc1tqTnppUOdLhFvg5-BrjX2i8mRytIuY',
    appId: '1:135805289633:web:99fff8fbc420a86eab9ce0',
    messagingSenderId: '135805289633',
    projectId: 'anvaya-e628f',
    authDomain: 'anvaya-e628f.firebaseapp.com',
    storageBucket: 'anvaya-e628f.firebasestorage.app',
    measurementId: 'G-3CMXD54CPD',
  );
}
