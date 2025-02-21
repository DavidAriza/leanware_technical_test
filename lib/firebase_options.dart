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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQMhLk5v6MplHu5OJT_EBg5rl4ziNVSYA',
    appId: '1:359021631368:android:ea0fc4dfd3cd68d93f4c3d',
    messagingSenderId: '359021631368',
    projectId: 'leanwaretest',
    storageBucket: 'leanwaretest.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDJrFbHRPKvteBW2Hue4PFg8BILRjIslXY',
    appId: '1:359021631368:ios:efea6f7b4f72c16d3f4c3d',
    messagingSenderId: '359021631368',
    projectId: 'leanwaretest',
    storageBucket: 'leanwaretest.firebasestorage.app',
    iosBundleId: 'io.agora.agoraRtcEngineExample',
  );

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyAVdLkAdppSHEjuFL_WAueAancO1BX9AuY",
      authDomain: "leanwaretest.firebaseapp.com",
      projectId: "leanwaretest",
      storageBucket: "leanwaretest.firebasestorage.app",
      messagingSenderId: "359021631368",
      appId: "1:359021631368:web:6dde50f22517cf323f4c3d");
}
