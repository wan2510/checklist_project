import '../../repositories/task_repository.dart';
import '../base_usecase.dart';

class DeleteTaskUseCase extends UseCase<void, String> {
  final TaskRepository _repository;

  DeleteTaskUseCase(this._repository);

  @override
  Future<void> call(String params) => _repository.deleteTask(params);
}