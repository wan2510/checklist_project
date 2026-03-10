import '../../entities/task.dart';
import '../../repositories/task_repository.dart';
import '../base_usecase.dart';

class WatchAllTasksUseCase extends StreamUseCaseNoParams<List<Task>> {
  final TaskRepository _repository;

  WatchAllTasksUseCase(this._repository);

  @override
  Stream<List<Task>> call() => _repository.watchAllTasks();
}