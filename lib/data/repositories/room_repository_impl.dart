import 'package:leanware_test/core/error_handling/failure.dart';
import 'package:leanware_test/core/utils/constants.dart';
import 'package:leanware_test/data/data_sources/room_remote_data_source.dart';
import 'package:leanware_test/data/models/room_model.dart';
import 'package:leanware_test/domain/repositories/room_repository.dart';
import 'package:dartz/dartz.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource remoteDataSource;
  final String FIXED_ROOM_ID = AppConstants.channel;

  RoomRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Unit>> setHostForRoom(String hostUid) async {
    try {
      final room = await remoteDataSource.getRoom();

      // Si ya hay un host, no sobrescribirlo
      if (room != null && room.hostUid.isNotEmpty) {
        return const Right(unit);
      }

      // Si no hay host, asignar el nuevo host
      final newRoom = RoomModel(
        hostUid: hostUid,
        createdAt: DateTime.now(),
      );
      await remoteDataSource.setRoomHost(newRoom);
      return const Right(unit);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> isUserHost(String uid) async {
    try {
      final room = await remoteDataSource.getRoom();
      return Right(room?.hostUid == uid);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, Unit>> clearRoom() async {
    try {
      await remoteDataSource.clearRoom();
      return const Right(unit);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
