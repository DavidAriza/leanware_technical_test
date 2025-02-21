part of 'call_cubit.dart';

sealed class CallState extends Equatable {
  const CallState();

  @override
  List<Object> get props => [];
}

final class CallInitial extends CallState {}

final class CallWaiting extends CallState {}

final class JoiningCall extends CallState {}

final class StartCall extends CallState {}

final class AskForUserName extends CallState {}

final class UserNameLoaded extends CallState {
  final String userName;

  const UserNameLoaded(this.userName);

  @override
  List<Object> get props => [userName];
}
