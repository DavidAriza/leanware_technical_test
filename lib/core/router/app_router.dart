import 'package:leanware_test/core/router/route_helper.dart';
import 'package:leanware_test/core/router/route_notifier.dart';
import 'package:leanware_test/domain/use_cases/get_data_from_local_use_case.dart';
import 'package:leanware_test/domain/use_cases/sign_up_use_case.dart';
import 'package:leanware_test/domain/use_cases/save_data_to_local_use_case.dart';
import 'package:leanware_test/injection_container.dart';
import 'package:leanware_test/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:leanware_test/presentation/cubits/call_cubit/call_cubit.dart';
import 'package:leanware_test/presentation/cubits/timer_cubit/timer_cubit.dart';
import 'package:leanware_test/presentation/screens/auth/register_screen.dart';
import 'package:leanware_test/presentation/screens/join_channel_audio_and_video_screen.dart/widgets/join_channel_audio_and_video_screen.dart';
import 'package:leanware_test/presentation/screens/join_to_call_screen/join_to_call_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GoRouterRefreshNotifier authNotifier =
    GoRouterRefreshNotifier(checkIfUserIsRegistered);

final GoRouter appRouter = GoRouter(
  refreshListenable: sl<GoRouterRefreshNotifier>(),
  routes: [
    GoRoute(
      path: '/register',
      name: '/register',
      builder: (context, state) => BlocProvider(
        create: (context) => AuthCubit(sl<SignUpUseCase>(),
            sl<SaveDataToLocalUseCase>(), sl<GoRouterRefreshNotifier>()),
        child: const RegisterScreen(),
      ),
    ),
    GoRoute(
        path: '/joinToCall',
        name: '/joinToCall',
        builder: (context, state) => JoinToCallScreen()),
    GoRoute(
        path: '/call',
        name: '/call',
        builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => TimerCubit(),
                ),
              ],
              child: JoinChannelAudioAndVideoScreen(),
            )),
  ],
  redirect: (context, state) async {
    final location = state.uri.toString();
    print("🔍 Redirect Check: Current location -> $location");
    final authNotifier = sl<GoRouterRefreshNotifier>();
    print("🟢 Auth State: ${authNotifier.value}");
    if (authNotifier.value == null) {
      print("⏳ Waiting for authentication check...");
      return '/register'; // Default while checking
    }

    // ✅ Fix: Redirect '/' to '/joinToCall' if authenticated
    if (authNotifier.value! && location == '/') {
      print("🔀 Redirecting from / to /joinToCall...");
      return '/joinToCall';
    }

    // ✅ Fix: Redirect '/' to '/register' if NOT authenticated
    if (!authNotifier.value! && location == '/') {
      print("🔀 Redirecting from / to /register...");
      return '/register';
    }

    if (authNotifier.value! && location == '/register') {
      print("🔀 Redirecting to /joinToCall...");
      return '/joinToCall';
    }

    if (!authNotifier.value! && location == '/joinToCall') {
      print("🔀 Redirecting to /register...");
      return '/register';
    }

    print("✅ No redirection needed, staying on $location");
    return null;
  },
);
