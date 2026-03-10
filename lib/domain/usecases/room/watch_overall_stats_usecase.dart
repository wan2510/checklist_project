import '../../entities/progress_stats.dart';
import '../../repositories/room_repository.dart';
import '../base_usecase.dart';

class WatchOverallStatsUseCase extends StreamUseCaseNoParams<ProgressStats> {
  final RoomRepository _repository;

  WatchOverallStatsUseCase(this._repository);

  @override
  Stream<ProgressStats> call() => _repository.watchOverallStats();
}