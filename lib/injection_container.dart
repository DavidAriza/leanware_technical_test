import 'package:leanware_test/core/http/dio_http_client.dart';
import 'package:leanware_test/core/router/route_helper.dart';
import 'package:leanware_test/core/router/route_notifier.dart';
import 'package:leanware_test/data/data_sources/auth_remote_data_source.dart';
import 'package:leanware_test/data/data_sources/room_remote_data_source.dart';
import 'package:leanware_test/data/repositories/auth_repository_impl.dart';
import 'package:leanware_test/data/repositories/local_data_repository_impl.dart';
import 'package:leanware_test/data/repositories/room_repository_impl.dart';
import 'package:leanware_test/domain/repositories/auth_repository.dart';
import 'package:leanware_test/domain/repositories/local_data_repository.dart';
import 'package:leanware_test/domain/repositories/room_repository.dart';
import 'package:leanware_test/domain/use_cases/clear_room_use_case.dart';
import 'package:leanware_test/domain/use_cases/get_data_from_local_use_case.dart';
import 'package:leanware_test/domain/use_cases/is_user_host_use_case.dart';
import 'package:leanware_test/domain/use_cases/set_room_host_use_case.dart';
import 'package:leanware_test/domain/use_cases/sign_up_use_case.dart';
import 'package:leanware_test/domain/use_cases/save_data_to_local_use_case.dart';
import 'package:leanware_test/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:leanware_test/presentation/cubits/call_cubit/call_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => AuthCubit(sl(), sl(), sl()));
  sl.registerFactory(() => CallCubit(sl(), sl(), sl(), sl(), sl()));

  sl.registerLazySingleton(
      () => GoRouterRefreshNotifier(checkIfUserIsRegistered));

  sl.registerLazySingleton(() => SignUpUseCase(authRepository: sl()));

  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authRemoteDataSource: sl()));

  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(httpClient: DioHttpClient()));

  sl.registerLazySingleton<RoomRemoteDataSource>(
      () => RoomRemoteDataSourceImpl(firestore: FirebaseFirestore.instance));

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  sl.registerSingleton<LocalDataRepository>(
    LocalDataRepositoryImpl(prefs: sharedPreferences),
  );
  sl.registerLazySingleton<RoomRepository>(
    () => RoomRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(() => SaveDataToLocalUseCase(sl<LocalDataRepository>()));
  sl.registerFactory(() => GetDataFromLocalUseCase(sl<LocalDataRepository>()));
  sl.registerLazySingleton(() => SetRoomHostUseCase(sl()));
  sl.registerLazySingleton(() => IsUserHostUseCase(sl()));
  sl.registerLazySingleton(() => ClearRoomUseCase(sl()));
}
