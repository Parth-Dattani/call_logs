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
    apiKey: 'AIzaSyBiIydcfu2gLNfCJTehAY8QuOYXIYcKPIQ',
    appId: '1:99352698401:web:53e7738ee2607926b94d60',
    messagingSenderId: '99352698401',
    projectId: 'caim-reader',
    authDomain: 'caim-reader.firebaseapp.com',
    storageBucket: 'caim-reader.appspot.com',
    measurementId: 'G-S1SDW55GQ5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBMCXK7Ylnq8EqhCfQGE33EZAlgRWINEYQ',
    appId: '1:268579197127:android:ad175a9fcfea78c9acaee2',
    messagingSenderId: '268579197127',
    projectId: 'logs-2ad17',
    storageBucket: 'logs-2ad17.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyASiAYnDnDd1A2mfKQfeFCSb-QASQAA6jk',
    appId: '1:268579197127:ios:43e9117de87f2f40acaee2',
    messagingSenderId: '268579197127',
    projectId: 'logs-2ad17',
    storageBucket: 'logs-2ad17.appspot.com',
    iosBundleId: 'com.example.logs',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC-FVFVnGS1mAMpo92Po9S6VwbVMYgOsws',
    appId: '1:99352698401:ios:798fe3e9a5c3aa43b94d60',
    messagingSenderId: '99352698401',
    projectId: 'caim-reader',
    storageBucket: 'caim-reader.appspot.com',
    iosBundleId: 'com.example.logs',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBiIydcfu2gLNfCJTehAY8QuOYXIYcKPIQ',
    appId: '1:99352698401:web:dbab0748c3679920b94d60',
    messagingSenderId: '99352698401',
    projectId: 'caim-reader',
    authDomain: 'caim-reader.firebaseapp.com',
    storageBucket: 'caim-reader.appspot.com',
    measurementId: 'G-8NMPB807L4',
  );
}