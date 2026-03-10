import 'package:floor/floor.dart';
import '../entities/room_entity.dart';

@dao
abstract class RoomDao {

  @Query('SELECT * FROM rooms ORDER BY sort_order ASC')
  Future<List<RoomEntity>> getAllRooms();

  @Query('SELECT * FROM rooms ORDER BY sort_order ASC')
  Stream<List<RoomEntity>> watchAllRooms();

  @Query('SELECT * FROM rooms WHERE room_type = :roomType LIMIT 1')
  Future<RoomEntity?> getRoomByType(String roomType);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertRoom(RoomEntity room);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertRooms(List<RoomEntity> rooms);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateRoom(RoomEntity room);

  @Query('DELETE FROM rooms WHERE id = :id')
  Future<void> deleteRoomById(String id);

  @Query('DELETE FROM rooms')
  Future<void> deleteAllRooms();
}