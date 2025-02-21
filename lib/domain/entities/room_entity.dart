import 'package:equatable/equatable.dart';

class RoomEntity extends Equatable {
  final String hostUid;
  final DateTime createdAt;

  RoomEntity({
    required this.hostUid,
    required this.createdAt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [hostUid, createdAt];
}
