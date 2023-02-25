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
    apiKey: 'AIzaSyCuvrEMcuRd2TPwtv2PCv_UTUGeTejqBNw',
    appId: '1:199814162232:web:72c8328934c595d3db03cd',
    messagingSenderId: '199814162232',
    projectId: 'groceries-a38d4',
    authDomain: 'groceries-a38d4.firebaseapp.com',
    storageBucket: 'groceries-a38d4.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_9pXx8B4AkqJ6Ww4hIa8WT0bfy7uKG24',
    appId: '1:199814162232:android:cf1835fd9958f698db03cd',
    messagingSenderId: '199814162232',
    projectId: 'groceries-a38d4',
    storageBucket: 'groceries-a38d4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAqZJo9xhdoSqMAAYoXvUOIToedPS_bcwc',
    appId: '1:199814162232:ios:2e3450239f85c1c7db03cd',
    messagingSenderId: '199814162232',
    projectId: 'groceries-a38d4',
    storageBucket: 'groceries-a38d4.appspot.com',
    iosClientId: '199814162232-nus0p0voh42gqghpj0hqice141pr3ko9.apps.googleusercontent.com',
    iosBundleId: 'com.example.groceryShopping',
  );
}