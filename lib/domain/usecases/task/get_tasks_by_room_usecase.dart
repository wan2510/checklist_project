import '../../../core/enums/room_type.dart';
import '../../entities/task.dart';
import '../../repositories/task_repository.dart';
import '../base_usecase.dart';

class GetTasksByRoomUseCase extends UseCase<List<Task>, RoomType> {
  final TaskRepository _repository;

  GetTasksByRoomUseCase(this._repository);

  @override
  Future<List<Task>> call(RoomType params) =>
      _repository.getTasksByRoom(params);
}