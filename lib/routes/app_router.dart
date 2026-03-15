import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../di/injection_container.dart';
import '../presentation/splash/splash_screen.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/room/room_list/room_list_screen.dart';
import '../presentation/room/room_detail/room_detail_screen.dart';
import '../presentation/task/all_tasks/all_tasks_screen.dart';
import '../presentation/task/task_detail/task_detail_screen.dart';
import '../presentation/calendar/calendar_screen.dart';
import '../presentation/report/report_screen.dart';
import '../presentation/settings/settings_screen.dart';
import '../presentation/home/home_viewmodel.dart';
import '../presentation/room/room_list_viewmodel.dart';
import '../presentation/room/room_detail/room_detail_viewmodel.dart';
import '../presentation/task/all_tasks/all_tasks_viewmodel.dart';
import '../presentation/task/task_detail/task_detail_viewmodel.dart';
import '../presentation/calendar/calendar_viewmodel.dart';
import '../presentation/report/report_viewmodel.dart';
import '../presentation/settings/settings_viewmodel.dart';
import '../presentation/splash/splash_viewmodel.dart';
import '../presentation/welcome/welcome_screen.dart';
import '../core/enums/room_type.dart';
import '../presentation/shared/widgets/tet_petal_overlay.dart'; // FIX: import overlay
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [

      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => SplashScreen(
          viewModel: sl<SplashViewModel>(),
        ),
      ),

      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),

      // ── Shell: Bottom Nav (5 tab) — wrap với TetPetalOverlay ───
      ShellRoute(
        builder: (context, state, child) => _MainShell(child: child),
        routes: [

          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => HomeScreen(
              viewModel: sl<HomeViewModel>(),
            ),
          ),

          GoRoute(
            path: AppRoutes.roomList,
            builder: (context, state) => RoomListScreen(
              viewModel: sl<RoomListViewModel>(),
            ),
            routes: [
              GoRoute(
                path: ':roomType',
                builder: (context, state) {
                  final roomTypeStr =
                      state.pathParameters['roomType'] ?? 'livingRoom';
                  final roomType = RoomType.fromString(roomTypeStr);
                  return RoomDetailScreen(
                    roomType:  roomType,
                    viewModel: sl<RoomDetailViewModel>(),
                  );
                },
              ),
            ],
          ),

          GoRoute(
            path: AppRoutes.allTasks,
            builder: (context, state) => AllTasksScreen(
              viewModel: sl<AllTasksViewModel>(),
            ),
            routes: [
              GoRoute(
                path: 'detail',
                builder: (context, state) {
                  final taskId = state.uri.queryParameters['taskId'];
                  return TaskDetailScreen(
                    taskId:    taskId,
                    viewModel: sl<TaskDetailViewModel>(),
                  );
                },
              ),
              GoRoute(
                path: 'add',
                builder: (context, state) => TaskDetailScreen(
                  taskId:    null,
                  viewModel: sl<TaskDetailViewModel>(),
                ),
              ),
            ],
          ),

          GoRoute(
            path: AppRoutes.calendar,
            builder: (context, state) => CalendarScreen(
              viewModel: sl<CalendarViewModel>(),
            ),
          ),

          GoRoute(
            path: AppRoutes.report,
            builder: (context, state) => ReportScreen(
              viewModel: sl<ReportViewModel>(),
            ),
          ),
        ],
      ),

      // ── Settings — cũng có hoa rơi ────────────────────────────
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => TetPetalOverlay(
          child: SettingsScreen(
            viewModel: sl<SettingsViewModel>(),
          ),
        ),
      ),
    ],
  );
}

// ── Main Shell ────────────────────────────────────────────────────
class _MainShell extends StatelessWidget {
  final Widget child;
  const _MainShell({required this.child});

  static const _tabs = [
    AppRoutes.home,
    AppRoutes.roomList,
    AppRoutes.allTasks,
    AppRoutes.calendar,
    AppRoutes.report,
  ];

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Scaffold(
      // FIX: bọc body + bottom nav trong TetPetalOverlay
      body: TetPetalOverlay(child: child),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => context.go(_tabs[index]),
        items: const [
          BottomNavigationBarItem(
            icon:       Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label:      'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon:       Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label:      'Phòng',
          ),
          BottomNavigationBarItem(
            icon:       Icon(Icons.checklist_outlined),
            activeIcon: Icon(Icons.checklist),
            label:      'Việc làm',
          ),
          BottomNavigationBarItem(
            icon:       Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label:      'Lịch',
          ),
          BottomNavigationBarItem(
            icon:       Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label:      'Báo cáo',
          ),
        ],
      ),
    );
  }
}