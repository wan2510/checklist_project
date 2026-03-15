import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
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

  // Giữ emoji cho dropdown / add_task_sheet
  String get iconPath {
    switch (this) {
      case RoomType.livingRoom: return '🛋️';
      case RoomType.kitchen:    return '🍳';
      case RoomType.bedroom:    return '🛏️';
      case RoomType.bathroom:   return '🚿';
      case RoomType.garden:     return '🌿';
      case RoomType.altar:      return '🕯️';
      case RoomType.other:      return '📦';
    }
  }

  // FIX: đúng type List<List<dynamic>> + đúng class HugeIcons (free package)
  // Tìm icon name: mở IDE → gõ HugeIcons.strokeRounded → dùng autocomplete
  List<List<dynamic>> get hugeIcon {
    switch (this) {
      case RoomType.livingRoom: return HugeIcons.strokeRoundedSofa01;
      case RoomType.kitchen:    return HugeIcons.strokeRoundedChefHat;
      case RoomType.bedroom:    return HugeIcons.strokeRoundedMoon02;
      case RoomType.bathroom:   return HugeIcons.strokeRoundedWaterEnergy;
      case RoomType.garden:     return HugeIcons.strokeRoundedFlower;
      case RoomType.altar:      return HugeIcons.strokeRoundedLocationStar01;
      case RoomType.other:      return HugeIcons.strokeRoundedPackageOpen;
    }
  }

  List<Color> get iconGradient {
    switch (this) {
      case RoomType.livingRoom:
        return [const Color(0xFFFF6B6B), const Color(0xFFE8344E)];
      case RoomType.kitchen:
        return [const Color(0xFFF5A623), const Color(0xFFFF8C00)];
      case RoomType.bedroom:
        return [const Color(0xFF7C5CBF), const Color(0xFF9B7FD4)];
      case RoomType.bathroom:
        return [const Color(0xFF2196F3), const Color(0xFF1976D2)];
      case RoomType.garden:
        return [const Color(0xFF4CAF50), const Color(0xFF388E3C)];
      case RoomType.altar:
        return [const Color(0xFFFF7043), const Color(0xFFE64A19)];
      case RoomType.other:
        return [const Color(0xFF9E9E9E), const Color(0xFF757575)];
    }
  }

  static RoomType fromString(String value) {
    return RoomType.values.firstWhere(
          (e) => e.name == value,
      orElse: () => RoomType.other,
    );
  }
}