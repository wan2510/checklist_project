import 'package:flutter/material.dart';

import '../../../domain/entities/room.dart';
import '../../../domain/repositories/room_repository.dart';
import '../../../domain/usecases/room/get_all_rooms_usecase.dart';

class RoomListViewModel extends ChangeNotifier {
  final GetAllRoomsUseCase _getAllRooms;
  final RoomRepository     _roomRepository;

  RoomListViewModel({
    required GetAllRoomsUseCase getAllRooms,
    required RoomRepository     watchAllRooms,
  })  : _getAllRooms     = getAllRooms,
        _roomRepository = watchAllRooms;

  // ── State ────────────────────────────────────────────────────
  List<Room> _rooms        = [];
  bool       _isLoading    = false;
  String?    _error;
  String     _searchQuery  = '';

  // ── Getters ──────────────────────────────────────────────────
  bool    get isLoading => _isLoading;
  String? get error     => _error;

  List<Room> get filteredRooms {
    if (_searchQuery.isEmpty) return _rooms;
    return _rooms.where((r) =>
        r.name.toLowerCase().contains(_searchQuery.toLowerCase()),
    ).toList();
  }

  int get totalTasks     => _rooms.fold(0, (s, r) => s + r.totalTasks);
  int get completedTasks => _rooms.fold(0, (s, r) => s + r.completedTasks);
  int get overdueTasks   => _rooms.fold(0, (s, r) => s + r.overdueTasks);

  double get overallProgress =>
      totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

  // ── Init ─────────────────────────────────────────────────────
  Future<void> init() async {
    _isLoading = true;
    _error     = null;
    notifyListeners();

    try {
      _rooms = await _getAllRooms();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Search ───────────────────────────────────────────────────
  void onSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> refresh() => init();
}