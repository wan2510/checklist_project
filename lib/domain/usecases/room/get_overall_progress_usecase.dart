import '../../entities/progress_stats.dart';
import '../../repositories/room_repository.dart';
import '../base_usecase.dart';

class GetOverallProgressUseCase extends UseCaseNoParams<ProgressStats> {
  final RoomRepository _repository;

  GetOverallProgressUseCase(this._repository);

  @override
  Future<ProgressStats> call() => _repository.getOverallStats();
}