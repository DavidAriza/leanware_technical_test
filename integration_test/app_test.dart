import 'package:leanware_test/core/router/app_router.dart';
import 'package:leanware_test/firebase_options.dart';
import 'package:leanware_test/main.dart';
import 'package:leanware_test/presentation/screens/join_to_call_screen/join_to_call_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leanware_test/main.dart' as app;
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart'; // Importa tu archivo main.dart
import 'package:patrol/patrol.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:leanware_test/injection_container.dart' as di;
import 'package:integration_test/integration_test.dart';

class MockPermissionHandler extends Mock implements Permission {}

// Función auxiliar para simular la concesión de permisos
// Future<void> mockPermissionsGranted() async {
//   when(mockPermissionHandler.request(Permission.microphone)).thenAnswer((_) async => PermissionStatus.granted);
//   when(mockPermissionHandler.request(Permission.camera)).thenAnswer((_) async => PermissionStatus.granted);
// }
void main() {
  patrolTest(
    'End-to-end test where it’s the first time the user signs up and is a host',
    framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    ($) async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await di.init();
      final testWidget = MaterialApp.router(
        routerConfig: appRouter,
      );
      await $.pumpWidgetAndSettle(testWidget);

      // Accept permissions for microphone & camera
      if (await $.native.isPermissionDialogVisible()) {
        await $.native.grantPermissionWhenInUse();
      }

      // Enter email & password
      await $(Key('email-field')).enterText('testuser@email.com');
      await $(Key('password-field')).enterText('testpassword');

      // Tap Signup button
      await $(Key('signup-button')).tap();
      await $.pumpAndSettle();

      // Wait for the JoinToCallScreen and check if "Join Call" button is visible
      await $(Key('popup-username-field')).enterText('testusername');
      await $(Key('popup-save-button')).tap();
      await $.pumpAndSettle();

      // Ensure "Join Call" button appears
      await $(Key('join-call-button')).tap();

      // Debugging print to confirm navigation
      print('Tapped Join Call button, waiting for transition...');

      // Wait and verify if user lands in the Waiting Room
      await $.waitUntilVisible(
        $(Text('Waiting room')),
        timeout: Duration(seconds: 15),
      );

      print('Test passed: User is in the Waiting Room.');
    },
  );
}
