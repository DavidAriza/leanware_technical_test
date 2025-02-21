import 'package:leanware_test/core/router/app_router.dart';
import 'package:leanware_test/core/utils/constants.dart';
import 'package:leanware_test/firebase_options.dart';
import 'package:leanware_test/injection_container.dart' as di;
import 'package:leanware_test/presentation/cubits/call_cubit/call_cubit.dart';
import 'package:leanware_test/presentation/screens/auth/register_screen.dart';
import 'package:leanware_test/presentation/screens/join_to_call_screen/join_to_call_screen.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferences.getInstance();
    await di.init();
  });

  group('Sign Up Screen Tests', () {
    testWidgets(
      'should find the sign up page at the beginning when no user has signed up ',
      (tester) async {
        final testWidget = MaterialApp.router(
          routerConfig: appRouter,
        );
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        expect(find.byType(RegisterScreen), findsOneWidget);
      },
    );

    // testWidgets(
    //   'should show JoinToCallScreen when user is logged in',
    //   (tester) async {
    //     // Configurar SharedPreferences con un usuario
    //     WidgetsFlutterBinding.ensureInitialized();
    //     SharedPreferences.setMockInitialValues({
    //       'UID': '12345', // Adjust key based on your implementation
    //       'USERNAME': 'test_user'
    //     });
    //     final prefs = await SharedPreferences.getInstance();
    //     // ✅ Reinitialize appRouter after setting SharedPreferences
    //     prefs.setString(AppConstants.uid, '12345');
    //     final testWidget = BlocProvider(
    //       create: (context) =>
    //           CallCubit(di.sl(), di.sl(), di.sl(), di.sl(), di.sl()),
    //       child: MaterialApp.router(
    //         routerConfig: appRouter,
    //       ),
    //     );

    //     await tester.pumpWidget(testWidget);
    //     await tester.pumpAndSettle();

    //     expect(find.byType(JoinToCallScreen), findsOneWidget);
    //     expect(find.byType(RegisterScreen), findsNothing);
    //   },
    // );

    testWidgets(
      'should find the textfield for email and password',
      (tester) async {
        final testWidget = MaterialApp.router(
          routerConfig: appRouter,
        );
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey('email-field')), findsOneWidget);
        expect(find.byKey(const ValueKey('password-field')), findsOneWidget);
      },
    );

    testWidgets(
      'should find error text when the email is invalid',
      (tester) async {
        final testWidget = MaterialApp.router(
          routerConfig: appRouter,
        );
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(const Key('email-field')), 'email');
        await tester.enterText(
            find.byKey(const Key('password-field')), 'password');
        await tester.tap(find.byKey(const Key('signup-button')));
        await tester.pump();

        expect(find.text('Enter a valid email'), findsOneWidget);
      },
    );
  });
}
