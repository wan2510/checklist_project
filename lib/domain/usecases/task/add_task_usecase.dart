import '../../entities/task.dart';
import '../../repositories/task_repository.dart';
import '../base_usecase.dart';

class AddTaskUseCase extends UseCase<void, Task> {
  final TaskRepository _repository;

  AddTaskUseCase(this._repository);

  @override
  Future<void> call(Task params) => _repository.addTask(params);
}