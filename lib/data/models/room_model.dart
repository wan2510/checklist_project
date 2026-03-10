import 'package:uuid/uuid.dart';
import '../../core/enums/room_type.dart';
import '../../domain/entities/room.dart';
import '../local/database/entities/room_entity.dart';

/// Mapper: RoomEntity (DB) ↔ Room (Domain)
class RoomModel {
  RoomModel._();

  static const _uuid = Uuid();

  // ── Entity → Domain (không có stats — stats tính từ tasks) ───
  static Room fromEntity(RoomEntity e) {
    return Room(
      id:   e.id,
      type: RoomType.fromString(e.roomType),
    );
  }

  // ── Domain → Entity ──────────────────────────────────────────
  static RoomEntity toEntity(Room r) {
    return RoomEntity(
      id:        r.id,
      roomType:  r.type.name,
      sortOrder: r.type.index,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  // ── Default rooms (seed data) ────────────────────────────────
  static List<RoomEntity> get defaultRooms {
    return RoomType.values.map((type) {
      return RoomEntity(
        id:        _uuid.v4(),
        roomType:  type.name,
        sortOrder: type.index,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
    }).toList();
  }
}