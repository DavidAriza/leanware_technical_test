import 'package:leanware_test/domain/use_cases/clear_room_use_case.dart';
import 'package:leanware_test/domain/use_cases/get_data_from_local_use_case.dart';
import 'package:leanware_test/domain/use_cases/is_user_host_use_case.dart';
import 'package:leanware_test/domain/use_cases/save_data_to_local_use_case.dart';
import 'package:leanware_test/core/utils/constants.dart';
import 'package:leanware_test/domain/use_cases/set_room_host_use_case.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'call_state.dart';

class CallCubit extends Cubit<CallState> {
  final GetDataFromLocalUseCase getDataFromLocalUseCase;
  final SaveDataToLocalUseCase saveDataToLocalUseCase;
  final SetRoomHostUseCase setRoomHostUseCase;
  final IsUserHostUseCase isUserHostUseCase;
  final ClearRoomUseCase clearRoomUseCase;
  CallCubit(this.getDataFromLocalUseCase, this.saveDataToLocalUseCase,
      this.setRoomHostUseCase, this.isUserHostUseCase, this.clearRoomUseCase)
      : super(CallInitial());

  void setToJoiningCallState() {
    emit(JoiningCall());
  }

  void setWaitingRoom() {
    emit(CallWaiting());
  }

  void setToInitial() {
    emit(CallInitial());
  }

  void startCall() {
    emit(StartCall());
  }

  void saveUserName(String userName) async {
    await saveDataToLocalUseCase.call(AppConstants.userName, userName);
    emit(UserNameLoaded(userName));
  }

  void getUserName(String key) async {
    final result = await getDataFromLocalUseCase.call(AppConstants.userName);
    result.fold((failure) {
      emit(AskForUserName());
    }, (userName) {
      if (userName.isEmpty) {
        emit(AskForUserName());
      } else {
        emit(UserNameLoaded(userName));
      }
    });
  }

  Future<String> getUserId() async {
    final result = await getDataFromLocalUseCase.call(AppConstants.uid);

    String? uid;
    result.fold((l) {
      uid = '';
    }, (uuid) {
      uid = uuid;
    });
    return uid ?? '';
  }

  Future<Map<String, dynamic>> setAndCheckIfItsHost() async {
    bool isTheHost = false;
    final currentUserId = await getUserId();

    await setRoomHostUseCase.call(currentUserId);

    final isHost = await isUserHostUseCase.call(currentUserId);
    isHost.fold((l) => null, (isHost) => isTheHost = isHost);

    return {"isHost": isTheHost, "uid": currentUserId};
  }

  Future<void> clearRoom() async {
    await clearRoomUseCase.call();
  }
}
