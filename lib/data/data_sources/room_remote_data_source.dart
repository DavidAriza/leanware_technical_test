import 'package:leanware_test/core/error_handling/exception.dart';
import 'package:leanware_test/core/utils/constants.dart';
import 'package:leanware_test/data/models/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RoomRemoteDataSource {
  Future<void> setRoomHost(RoomModel room);
  Future<RoomModel?> getRoom();
  Future<void> clearRoom();
}

class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
  final FirebaseFirestore firestore;
  RoomRemoteDataSourceImpl({required this.firestore});
  final String channel = AppConstants.channel;
  @override
  Future<void> setRoomHost(RoomModel room) async {
    try {
      await firestore.collection('rooms').doc(channel).set(
            room.toJson(),
          );
    } catch (e) {
      throw RoomException('Failed to set room host: ${e.toString()}');
    }
  }

  @override
  Future<RoomModel?> getRoom() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>>? doc =
          await firestore.collection('rooms').doc(channel).get();
      final Map<String, dynamic>? data = doc?.data();
      if (data == null) {
        return null; // Return null if document doesn't exist
      }
      return RoomModel.fromJson(doc!.data()!);
    } catch (e) {
      throw RoomException('Failed to get room: ${e.toString()}');
    }
  }

  @override
  Future<void> clearRoom() async {
    try {
      await firestore.collection('rooms').doc(channel).delete();
    } catch (e) {
      throw RoomException('Failed to clear room: ${e.toString()}');
    }
  }
}
