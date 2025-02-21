import 'dart:async';

import 'package:leanware_test/domain/use_cases/clear_room_use_case.dart';
import 'package:leanware_test/domain/use_cases/is_user_host_use_case.dart';
import 'package:leanware_test/domain/use_cases/set_room_host_use_case.dart';
import 'package:leanware_test/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:leanware_test/core/router/app_router.dart';
import 'package:leanware_test/domain/use_cases/get_data_from_local_use_case.dart';
import 'package:leanware_test/domain/use_cases/save_data_to_local_use_case.dart';
import 'package:leanware_test/injection_container.dart';
import 'package:leanware_test/presentation/cubits/call_cubit/call_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leanware_test/firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:leanware_test/injection_container.dart' as di;

void main() async {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await di.init();
    runApp(const MyApp());
  }, (error, stackTrace) {});
}

/// This widget is the root of your application.
class MyApp extends StatefulWidget {
  /// Construct the [MyApp]
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    _requestPermissionIfNeed();
  }

  Future<void> _requestPermissionIfNeed() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await [Permission.audio, Permission.microphone, Permission.camera]
          .request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CallCubit(
              sl<GetDataFromLocalUseCase>(),
              sl<SaveDataToLocalUseCase>(),
              sl<SetRoomHostUseCase>(),
              sl<IsUserHostUseCase>(),
              sl<ClearRoomUseCase>()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
