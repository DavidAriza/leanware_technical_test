import 'package:leanware_test/core/router/route_notifier.dart';
import 'package:leanware_test/core/use_case/login_params.dart';
import 'package:leanware_test/core/utils/constants.dart';
import 'package:leanware_test/domain/entities/login_response_entity.dart';
import 'package:leanware_test/domain/use_cases/sign_up_use_case.dart';
import 'package:leanware_test/domain/use_cases/save_data_to_local_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignUpUseCase signUpUseCase;
  final SaveDataToLocalUseCase saveDataToLocalUseCase;
  final GoRouterRefreshNotifier authNotifier;

  AuthCubit(this.signUpUseCase, this.saveDataToLocalUseCase, this.authNotifier)
      : super(AuthInitial());

  Future<void> signup(String email, String password) async {
    emit(AuthLoading());

    final result =
        await signUpUseCase.call(LoginParams(email: email, password: password));
    result.fold((l) => emit(AuthError(l.message)), (loginResponse) async {
      await saveUIdLocally(loginResponse.id);
      await authNotifier.refresh(); //
      emit(AuthLoaded(loginResponse));
    });
  }

  Future<void> saveUIdLocally(String uid) async {
    const key = AppConstants.uid;
    await saveDataToLocalUseCase.call(key, uid);
  }
}
