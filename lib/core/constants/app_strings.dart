class AppStrings {
  AppStrings._();

  // ── App ──────────────────────────────────────────────────────
  static const String appName        = 'Dọn Nhà Đón Tết';
  static const String appSlogan      = 'Sẵn Sàng Đón Tết';
  static const String appDescription =
      'Sắp xếp kế hoạch dọn dẹp nhà cửa thông minh để đón một năm mới an khang, thịnh vượng.';

  // ── Splash ───────────────────────────────────────────────────
  static const String splashLoading  = 'ĐANG CHUẨN BỊ...';

  // ── Home ─────────────────────────────────────────────────────
  static const String homeTitle      = 'Cùng dọn nào!';
  static const String homeSubtitle   = 'Sẵn sàng đón Tết';
  static const String countdownPrefix = 'Còn';
  static const String countdownSuffix = 'Ngày';
  static const String countdownMsg   = 'Đừng quên dọn dẹp nhà cửa nhé!';
  static const String overallProgress = 'TIẾN ĐỘ TỔNG THỂ';
  static const String quickStats     = 'Thống kê nhanh';
  static const String viewAll        = 'Xem tất cả >';
  static const String explore        = 'Khám phá';

  // ── Quick stats ──────────────────────────────────────────────
  static const String statToday      = 'HÔM NAY';
  static const String statPriority   = 'ƯU TIÊN';
  static const String statNearDue    = 'QUÁ HẠN';
  static const String taskNeedDone   = 'việc cần làm';
  static const String taskHighPriority = 'việc quan trọng';
  static const String taskNearDeadline = 'việc cần xử lý';

  // ── Navigation ───────────────────────────────────────────────
  static const String navHome        = 'Trang chủ';
  static const String navRoom        = 'Phòng';
  static const String navTask        = 'Việc làm';
  static const String navCalendar    = 'Lịch';
  static const String navReport      = 'Báo cáo';
  static const String navSettings    = 'Cài đặt';

  // ── Menu grid ────────────────────────────────────────────────
  static const String menuRoomList   = 'Danh sách theo phòng';
  static const String menuAllTasks   = 'Tất cả công việc';
  static const String menuCalendar   = 'Lịch trình dọn dẹp';
  static const String menuReport     = 'Báo cáo tiến độ';

  // ── Room names ───────────────────────────────────────────────
  static const String roomLivingRoom = 'Phòng khách';
  static const String roomKitchen    = 'Nhà bếp';
  static const String roomBedroom    = 'Phòng ngủ';
  static const String roomBathroom   = 'Nhà tắm';
  static const String roomGarden     = 'Sân vườn';
  static const String roomAltar      = 'Phòng thờ';
  static const String roomOther      = 'Khác';

  // ── Task detail ──────────────────────────────────────────────
  static const String taskTitle          = 'TÊN CÔNG VIỆC';
  static const String taskDescription    = 'MÔ TẢ CHI TIẾT';
  static const String taskRoom           = 'PHÒNG';
  static const String taskPriority       = 'ƯU TIÊN';
  static const String taskDeadline       = 'Hạn chót';
  static const String taskDeadlineHint   = 'Thời gian cần hoàn thành';
  static const String taskReminder       = 'Nhắc nhở';
  static const String taskReminderHint   = 'Thông báo định kỳ';
  static const String taskProgress       = 'TIẾN ĐỘ HOÀN THÀNH';
  static const String taskNote           = 'GHI CHÚ THÊM';
  static const String progressStart      = 'BẮT ĐẦU';
  static const String progressInProgress = 'ĐANG LÀM';
  static const String progressDone       = 'XONG';

  // ── Priority labels ──────────────────────────────────────────
  static const String priorityHigh   = 'Cao';
  static const String priorityMedium = 'Trung bình';
  static const String priorityLow    = 'Thấp';

  // ── Status labels ────────────────────────────────────────────
  static const String statusAll        = 'Tất cả';
  static const String statusPending    = 'Chưa làm';
  static const String statusInProgress = 'Đang làm';
  static const String statusDone       = 'Hoàn thành';
  static const String statusOverdue    = 'Quá hạn';
  static const String statusToday      = 'Hôm nay';
  static const String statusThisWeek   = 'Tuần này';
  static const String statusHighPriority = 'Ưu tiên cao';

  // ── Sort options ─────────────────────────────────────────────
  static const String sortByDeadline   = 'Theo deadline';
  static const String sortByPriority   = 'Theo ưu tiên';
  static const String sortByRoom       = 'Theo phòng';
  static const String sortByProgress   = 'Theo % hoàn thành';

  // ── Actions ──────────────────────────────────────────────────
  static const String actionSave         = 'Lưu công việc';
  static const String actionCancel       = 'Hủy';
  static const String actionDelete       = 'Xóa';
  static const String actionEdit         = 'Chỉnh sửa';
  static const String actionComplete     = 'Đánh dấu hoàn thành';
  static const String actionDuplicate    = 'Nhân bản';
  static const String actionAdd          = 'Thêm';
  static const String actionAddContinue  = 'Thêm & Tiếp tục';
  static const String actionRemindLater  = 'Nhắc tôi sau';

  // ── Report ───────────────────────────────────────────────────
  static const String reportTitle       = 'Báo cáo tiến độ';
  static const String reportTotal       = 'TẤT CẢ';
  static const String reportDone        = 'HOÀN TẤT';
  static const String reportInProgress  = 'TIẾN HÀNH';
  static const String reportNeedAttention = 'CẦN CHÚ Ý';
  static const String reportEfficiency  = 'HIỆU SUẤT';
  static const String reportAvgTime     = '45 phút / việc';
  static const String reportAvgTimeDesc = 'Thời gian trung bình hoàn thành';
  static const String reportCompletionStatus = 'Trang thái hoàn thành';
  static const String reportWeeklyPerf  = 'Hiệu suất theo tuần';
  static const String reportRoomDist    = 'Phân bổ theo phòng';
  static const String reportMilestone   = 'MỐC QUAN TRỌNG SẮP TỚI';

  // ── Motivation messages ──────────────────────────────────────
  static const String motivationLow     = 'Cố lên! Tết đang đến gần! ';
  static const String motivationMid     = 'Tuyệt vời! Sắp xong rồi! ';
  static const String motivationHigh    = 'Xuất sắc! Nhà bạn sẵn sàng đón Tết! ';

  // ── Achievement ──────────────────────────────────────────────
  static const String achievementTitle  = 'Thành tích:';
  static const String achievementMaster = 'Bậc Thầy Dọn Dẹp';

  // ── Settings ─────────────────────────────────────────────────
  static const String settingsTitle        = 'Cài đặt';
  static const String settingsNotification = 'THÔNG BÁO';
  static const String settingsAllowNotif   = 'Cho phép thông báo';
  static const String settingsAllowNotifSub = 'Nhận tin nhắc nhở mọi lúc';
  static const String settingsDefaultReminder = 'Nhắc nhở mặc định';
  static const String settingsDefaultReminderSub = 'Tự động nhắc nhở vào lúc 8:00';
  static const String settingsSound        = 'Âm thanh thông báo';
  static const String settingsSoundSub     = 'Bật âm báo khi có việc';
  static const String settingsUI           = 'GIAO DIỆN';
  static const String settingsDarkMode     = 'Chế độ tối';
  static const String settingsDarkModeSub  = 'Thay đổi giao diện sáng';
  static const String settingsThemeColor   = 'Màu chủ đạo';
  static const String settingsThemeColorSub = 'Thay đổi màu sắc thường';
  static const String settingsData         = 'DỮ LIỆU';
  static const String settingsBackup       = 'Sao lưu & Phục hồi';
  static const String settingsBackupSub    = 'Quản lý dữ liệu trên đám mây';
  static const String settingsExport       = 'Xuất dữ liệu';
  static const String settingsExportSub    = 'Xuất sang file Excel hoặc lại';
  static const String settingsRefresh      = 'Làm mới ứng dụng';
  static const String settingsRefreshSub   = 'Xóa cache và tải lại';
  static const String settingsDeleteAll    = 'Xóa tất cả dữ liệu';
  static const String settingsDeleteAllSub = 'Hành động này không thể hoàn lại';
  static const String settingsAbout        = 'VỀ ỨNG DỤNG';
  static const String settingsGuide        = 'Hướng dẫn sử dụng';
  static const String settingsGuideSub     = 'Cách sử dụng checklist hiệp';
  static const String settingsFeedback     = 'Liên hệ & Góp ý';
  static const String settingsFeedbackSub  = 'Chúng tôi luôn lắng nghe.';
  static const String settingsVersion      = 'Phiên bản';
  static const String settingsVersionValue = 'v1.0.4 (Build 202)';
  static const String settingsNewVersion   = 'Mới nhất';
  static const String settingsFooter       = 'Chúc bạn một mùa Tết ấm cúng và sạch sẽ! ';

  // ── Calendar ─────────────────────────────────────────────────
  static const String calendarTitle  = 'Lịch trình Tết 2026';
  static const String calendarMonth  = 'Tháng';
  static const String calendarAgenda = 'Agenda';
  static const String calendarLunar  = 'Tết Bính Ngọ';
  static const List<String> weekDays = ['T2','T3','T4','T5','T6','T7','CN'];
  static const String legendHigh     = 'Ưu tiên cao';
  static const String legendDeadline = 'Deadline';
  static const String legendNormal   = 'Bình thường';

  // ── Dialog ───────────────────────────────────────────────────
  static const String dialogExitTitle   = 'Thoát app?';
  static const String dialogExitContent = 'Bạn có chắc muốn thoát ứng dụng không?';
  static const String dialogDeleteTitle = 'Xóa công việc?';
  static const String dialogDeleteContent = 'Hành động này không thể hoàn lại.';
  static const String dialogConfirm     = 'Xác nhận';
  static const String dialogYes         = 'Có';
  static const String dialogNo          = 'Không';

  // ── Placeholder / Hints ──────────────────────────────────────
  static const String hintSearchRoom    = 'Tìm kiếm phòng...';
  static const String hintSearchTask    = 'Tìm kiếm công việc, phòng...';
  static const String hintTaskName      = 'Nhập tên công việc...';
  static const String hintDescription   = 'Mô tả chi tiết công việc cần làm...';
  static const String hintNote          = 'Ghi chú thêm...';

  // ── Progress label ───────────────────────────────────────────
  static const String taskDone          = 'việc hoàn thành';
  static const String overdue           = 'việc đã quá hạn - Cần xử lý ngay!';
  static const String roomProgress      = 'việc hoàn thành';
  static const String updateLatest      = 'Cập nhật mới nhất';
  static const String roomsZone         = 'Khu vực dọn dẹp';
  static const String roomsUntilTet     = 'Tết 2026 đang đến rất gần!';
  static const String overallSummary    = 'Tình trạng tổng thể';

  // ── Quote / Inspiration ──────────────────────────────────────
  static const String homeQuote =
      '"Nhà sạch thì mát, bát sạch ngon cơm. Cố gắng dọn dẹp để đón một cái Tết thật trọn vẹn nhé!"';
}