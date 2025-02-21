import 'package:leanware_test/core/error_handling/failure.dart';
import 'package:leanware_test/domain/repositories/room_repository.dart';
import 'package:dartz/dartz.dart';

class SetRoomHostUseCase {
  final RoomRepository repository;

  SetRoomHostUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String hostUid) {
    return repository.setHostForRoom(hostUid);
  }
}
