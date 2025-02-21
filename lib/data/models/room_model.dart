import 'package:leanware_test/domain/entities/room_entity.dart';

class RoomModel extends RoomEntity {
  RoomModel({
    required String hostUid,
    required DateTime createdAt,
  }) : super(
          hostUid: hostUid,
          createdAt: createdAt,
        );

  Map<String, dynamic> toJson() {
    return {
      'hostUid': hostUid,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      hostUid: json['hostUid'] ?? '',
      createdAt: DateTime.tryParse(
              json['createdAt'] ?? DateTime.now().toIso8601String()) ??
          DateTime.now(),
    );
  }
}
