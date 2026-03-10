import '../../entities/task.dart';
import '../../repositories/task_repository.dart';
import '../base_usecase.dart';

class GetTasksByDateUseCase extends UseCase<List<Task>, DateTime> {
  final TaskRepository _repository;

  GetTasksByDateUseCase(this._repository);

  @override
  Future<List<Task>> call(DateTime params) =>
      _repository.getTasksByDate(params);
}