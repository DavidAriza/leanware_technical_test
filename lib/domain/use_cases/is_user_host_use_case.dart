import 'package:leanware_test/core/error_handling/failure.dart';
import 'package:leanware_test/domain/repositories/room_repository.dart';
import 'package:dartz/dartz.dart';

class IsUserHostUseCase {
  final RoomRepository repository;

  IsUserHostUseCase(this.repository);

  Future<Either<Failure, bool>> call(String uid) {
    return repository.isUserHost(uid);
  }
}
