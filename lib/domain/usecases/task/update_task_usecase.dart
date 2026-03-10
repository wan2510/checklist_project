import '../../entities/task.dart';
import '../../repositories/task_repository.dart';
import '../base_usecase.dart';

class UpdateTaskUseCase extends UseCase<void, Task> {
  final TaskRepository _repository;

  UpdateTaskUseCase(this._repository);

  @override
  Future<void> call(Task params) => _repository.updateTask(params);
}