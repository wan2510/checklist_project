import '../constants/app_strings.dart';

enum RoomType {
  livingRoom,
  kitchen,
  bedroom,
  bathroom,
  garden,
  altar,
  other;

  String get label {
    switch (this) {
      case RoomType.livingRoom: return AppStrings.roomLivingRoom;
      case RoomType.kitchen:    return AppStrings.roomKitchen;
      case RoomType.bedroom:    return AppStrings.roomBedroom;
      case RoomType.bathroom:   return AppStrings.roomBathroom;
      case RoomType.garden:     return AppStrings.roomGarden;
      case RoomType.altar:      return AppStrings.roomAltar;
      case RoomType.other:      return AppStrings.roomOther;
    }
  }

  String get iconPath {
    switch (this) {
      case RoomType.livingRoom: return '🛋️';
      case RoomType.kitchen:    return '🍳';
      case RoomType.bedroom:    return '🛏️';
      case RoomType.bathroom:   return '🚿';
      case RoomType.garden:     return '🌿';
      case RoomType.altar:      return '🔥';
      case RoomType.other:      return '📦';
    }
  }

  static RoomType fromString(String value) {
    return RoomType.values.firstWhere(
          (e) => e.name == value,
      orElse: () => RoomType.other,
    );
  }
}