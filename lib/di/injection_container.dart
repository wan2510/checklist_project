import 'package:get_it/get_it.dart';

import '../data/local/database/app_database.dart';
import '../data/local/database/dao/room_dao.dart';
import '../data/local/database/dao/task_dao.dart';
import '../data/local/preferences/app_preferences.dart';
import '../data/repositories/task_repository_impl.dart';
import '../data/repositories/room_repository_impl.dart';
import '../domain/repositories/task_repository.dart';
import '../domain/repositories/room_repository.dart';
import '../domain/usecases/task/get_all_tasks_usecase.dart';
import '../domain/usecases/task/get_tasks_by_room_usecase.dart';
import '../domain/usecases/task/get_tasks_by_date_usecase.dart';
import '../domain/usecases/task/get_today_tasks_usecase.dart';
import '../domain/usecases/task/get_overdue_tasks_usecase.dart';
import '../domain/usecases/task/search_tasks_usecase.dart';
import '../domain/usecases/task/add_task_usecase.dart';
import '../domain/usecases/task/update_task_usecase.dart';
import '../domain/usecases/task/delete_task_usecase.dart';
import '../domain/usecases/task/toggle_task_complete_usecase.dart';
import '../domain/usecases/task/watch_all_tasks_usecase.dart';
import '../domain/usecases/room/get_all_rooms_usecase.dart';
import '../domain/usecases/room/get_overall_progress_usecase.dart';
import '../domain/usecases/room/watch_overall_stats_usecase.dart';
import '../presentation/home/home_viewmodel.dart';
import '../presentation/room/room_detail/room_detail_viewmodel.dart';
import '../presentation/room/room_list_viewmodel.dart';
import '../presentation/task/all_tasks/all_tasks_viewmodel.dart';
import '../presentation/task/task_detail/task_detail_viewmodel.dart';
import '../presentation/calendar/calendar_viewmodel.dart';
import '../presentation/report/report_viewmodel.dart';
import '../presentation/settings/settings_viewmodel.dart';
import '../presentation/splash/splash_viewmodel.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {

  // ── 1. External / Core — Singleton ───────────────────────────
  final db    = await AppDatabase.getInstance();
  final prefs = await AppPreferences.create();

  sl.registerSingleton<AppDatabase>(db);
  sl.registerSingleton<AppPreferences>(prefs);

  // ── 2. DAOs — Singleton ───────────────────────────────────────
  sl.registerSingleton(db.taskDao);
  sl.registerSingleton(db.roomDao);

  // ── 3. Repositories — Singleton ──────────────────────────────
  sl.registerSingleton<TaskRepository>(
    TaskRepositoryImpl(sl()),
  );
  sl.registerSingleton<RoomRepository>(
    RoomRepositoryImpl(sl<RoomDao>(), sl<TaskDao>()),
  );

  // ── 4. Task UseCases — LazySingleton ─────────────────────────
  sl.registerLazySingleton(() => GetAllTasksUseCase(sl()));
  sl.registerLazySingleton(() => GetTasksByRoomUseCase(sl()));
  sl.registerLazySingleton(() => GetTasksByDateUseCase(sl()));
  sl.registerLazySingleton(() => GetTodayTasksUseCase(sl()));
  sl.registerLazySingleton(() => GetOverdueTasksUseCase(sl()));
  sl.registerLazySingleton(() => SearchTasksUseCase(sl()));
  sl.registerLazySingleton(() => AddTaskUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));
  sl.registerLazySingleton(() => ToggleTaskCompleteUseCase(sl()));
  sl.registerLazySingleton(() => WatchAllTasksUseCase(sl()));

  // ── 5. Room UseCases — LazySingleton ─────────────────────────
  sl.registerLazySingleton(() => GetAllRoomsUseCase(sl()));
  sl.registerLazySingleton(() => GetOverallProgressUseCase(sl()));
  sl.registerLazySingleton(() => WatchOverallStatsUseCase(sl()));

  // ── 6. ViewModels ─────────────────────────────────────────────

  // Splash — Factory (chỉ dùng 1 lần)
  sl.registerFactory(() => SplashViewModel(sl()));

  // Bottom nav — LazySingleton (không tạo lại khi navigate)
  sl.registerLazySingleton(() => HomeViewModel(
    getOverallProgress: sl(),
    watchOverallStats:  sl(),
    getTodayTasks:      sl(),
    getOverdueTasks:    sl(),
  ));

  sl.registerLazySingleton(() => RoomListViewModel(
    getAllRooms:   sl(),
    watchAllRooms: sl<RoomRepository>(),
  ));

  sl.registerLazySingleton(() => AllTasksViewModel(
    getAllTasks:        sl(),
    watchAllTasks:      sl(),
    getTodayTasks:      sl(),
    getOverdueTasks:    sl(),
    searchTasks:        sl(),
    toggleTaskComplete: sl(),
    deleteTask:         sl(),
  ));

  sl.registerLazySingleton(() => CalendarViewModel(
    getTasksByDate: sl(),
    getAllTasks:     sl(),
  ));

  sl.registerLazySingleton(() => ReportViewModel(
    getOverallProgress: sl(),
    watchOverallStats:  sl(),
  ));

  // Detail screens — Factory (cần fresh data mỗi lần mở)
  sl.registerFactory(() => RoomDetailViewModel(
    getTasksByRoom:     sl(),
    watchTasksByRoom:   sl<TaskRepository>(),
    toggleTaskComplete: sl(),
    deleteTask:         sl(),
  ));

  sl.registerFactory(() => TaskDetailViewModel(
    addTask:    sl(),
    updateTask: sl(),
    deleteTask: sl(),
    prefs:      sl(),
  ));

  sl.registerLazySingleton(() => SettingsViewModel(prefs: sl()));
}