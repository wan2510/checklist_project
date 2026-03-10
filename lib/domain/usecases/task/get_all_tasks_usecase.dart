import '../../entities/task.dart';
import '../../repositories/task_repository.dart';
import '../base_usecase.dart';

class GetAllTasksUseCase extends UseCaseNoParams<List<Task>> {
  final TaskRepository _repository;

  GetAllTasksUseCase(this._repository);

  @override
  Future<List<Task>> call() => _repository.getAllTasks();
}