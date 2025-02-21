import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  static const int _duration = 70;
  Timer? _timer;

  TimerCubit() : super(const TimerInitial(_duration));

  void startTimer() {
    emit(const TimerRunning(_duration));
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (timer.tick >= _duration) {
          _timer?.cancel();
          emit(const TimerFinished());
        } else {
          emit(TimerRunning(_duration - timer.tick));
        }
      },
    );
  }

  void stopTimer() {
    _timer?.cancel();
    emit(const TimerInitial(_duration));
  }

  void pauseTimer() {
    _timer?.cancel();
  }

  void resumeTimer() {
    if (state is TimerRunning) {
      startTimer();
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
