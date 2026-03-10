import '../../entities/room.dart';
import '../../repositories/room_repository.dart';
import '../base_usecase.dart';

class GetAllRoomsUseCase extends UseCaseNoParams<List<Room>> {
  final RoomRepository _repository;

  GetAllRoomsUseCase(this._repository);

  @override
  Future<List<Room>> call() => _repository.getAllRooms();
}