import '../../entities/task.dart';
import '../../repositories/task_repository.dart';
import '../base_usecase.dart';

class SearchTasksUseCase extends UseCase<List<Task>, String> {
  final TaskRepository _repository;

  SearchTasksUseCase(this._repository);

  @override
  Future<List<Task>> call(String params) =>
      _repository.searchTasks(params);
}