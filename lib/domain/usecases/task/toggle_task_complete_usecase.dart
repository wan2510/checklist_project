import '../../../core/enums/task_status.dart';
import '../../entities/task.dart';
import '../../repositories/task_repository.dart';
import '../base_usecase.dart';

class ToggleTaskCompleteUseCase extends UseCase<void, Task> {
  final TaskRepository _repository;

  ToggleTaskCompleteUseCase(this._repository);

  @override
  Future<void> call(Task params) {
    final updatedTask = params.isCompleted
    // Nếu đang done → quay về pending
        ? params.copyWith(
      status:          TaskStatus.pending,
      progressPercent: 0,
      updatedAt:       DateTime.now().toUtc().add(const Duration(hours: 7)),
    )
    // Nếu chưa done → mark done
        : params.copyWith(
      status:          TaskStatus.done,
      progressPercent: 100,
      updatedAt:       DateTime.now().toUtc().add(const Duration(hours: 7)),
    );

    return _repository.updateTask(updatedTask);
  }
}