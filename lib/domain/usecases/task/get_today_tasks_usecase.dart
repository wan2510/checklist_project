import '../../entities/task.dart';
import '../../repositories/task_repository.dart';
import '../base_usecase.dart';

class GetTodayTasksUseCase extends UseCaseNoParams<List<Task>> {
  final TaskRepository _repository;

  GetTodayTasksUseCase(this._repository);

  @override
  Future<List<Task>> call() => _repository.getTodayTasks();
}