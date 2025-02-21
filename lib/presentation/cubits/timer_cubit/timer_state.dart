part of 'timer_cubit.dart';

sealed class TimerState {
  final int timeLeft;
  const TimerState(this.timeLeft);
}

final class TimerInitial extends TimerState {
  const TimerInitial(super.timeLeft);
}

final class TimerRunning extends TimerState {
  const TimerRunning(super.timeLeft);
}

final class TimerFinished extends TimerState {
  const TimerFinished() : super(0);
}
