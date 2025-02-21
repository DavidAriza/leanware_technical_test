import 'package:leanware_test/core/error_handling/failure.dart';
import 'package:dartz/dartz.dart';

abstract class RoomRepository {
  Future<Either<Failure, Unit>> setHostForRoom(String hostUid);
  Future<Either<Failure, bool>> isUserHost(String uid);
  Future<Either<Failure, Unit>> clearRoom();
}
