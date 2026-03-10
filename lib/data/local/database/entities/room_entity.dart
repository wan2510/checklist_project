import 'package:floor/floor.dart';

/// Room không lưu DB riêng — được tính toán (aggregate) từ tasks.
/// File này dự phòng nếu sau cần custom room (tên, icon, thứ tự).
@Entity(tableName: 'rooms')
class RoomEntity {
  @PrimaryKey()
  final String id;

  @ColumnInfo(name: 'room_type')
  final String roomType; // RoomType.name

  @ColumnInfo(name: 'custom_name')
  final String? customName; // Tên tùy chỉnh (nullable)

  @ColumnInfo(name: 'sort_order')
  final int sortOrder; // Thứ tự hiển thị

  @ColumnInfo(name: 'created_at')
  final int createdAt;

  const RoomEntity({
    required this.id,
    required this.roomType,
    this.customName,
    required this.sortOrder,
    required this.createdAt,
  });
}