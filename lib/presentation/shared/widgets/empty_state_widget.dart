import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class EmptyStateWidget extends StatelessWidget {
  final String    emoji;
  final String    title;
  final String    subtitle;
  final String?   actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  // ── Preset factories ──────────────────────────────────────────

  factory EmptyStateWidget.noTasks({VoidCallback? onAdd}) =>
      EmptyStateWidget(
        emoji:       '🎉',
        title:       'Không có công việc nào!',
        subtitle:    'Nhấn nút + để thêm công việc mới.',
        actionLabel: 'Thêm việc',
        onAction:    onAdd,
      );

  factory EmptyStateWidget.allDone() =>
      const EmptyStateWidget(
        emoji:    '✅',
        title:    'Hoàn thành tất cả!',
        subtitle: 'Nhà bạn đã sẵn sàng đón Tết rồi! 🏮',
      );

  factory EmptyStateWidget.noResults() =>
      const EmptyStateWidget(
        emoji:    '🔍',
        title:    'Không tìm thấy kết quả',
        subtitle: 'Thử tìm kiếm với từ khóa khác nhé.',
      );

  factory EmptyStateWidget.noOverdue() =>
      const EmptyStateWidget(
        emoji:    '👏',
        title:    'Không có việc quá hạn!',
        subtitle: 'Bạn đang quản lý công việc rất tốt.',
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Emoji ───────────────────────────────────────────
            Text(
              emoji,
              style: const TextStyle(fontSize: 56),
            ),
            const SizedBox(height: AppDimensions.spaceLG),

            // ── Title ───────────────────────────────────────────
            Text(
              title,
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceSM),

            // ── Subtitle ─────────────────────────────────────────
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey500,
              ),
              textAlign: TextAlign.center,
            ),

            // ── Action button ────────────────────────────────────
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.spaceXXL),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}