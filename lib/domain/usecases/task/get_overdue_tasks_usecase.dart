import '../../entities/task.dart';
import '../../repositories/task_repository.dart';
import '../base_usecase.dart';

class GetOverdueTasksUseCase extends UseCaseNoParams<List<Task>> {
  final TaskRepository _repository;

  GetOverdueTasksUseCase(this._repository);

  @override
  Future<List<Task>> call() => _repository.getOverdueTasks();
}