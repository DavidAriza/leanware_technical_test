import 'package:leanware_test/core/error_handling/failure.dart';
import 'package:leanware_test/domain/repositories/room_repository.dart';
import 'package:dartz/dartz.dart';

class ClearRoomUseCase {
  final RoomRepository repository;

  ClearRoomUseCase(this.repository);

  Future<Either<Failure, Unit>> call() {
    return repository.clearRoom();
  }
}
