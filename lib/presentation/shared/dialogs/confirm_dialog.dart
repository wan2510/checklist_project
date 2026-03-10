import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class ConfirmDialog extends StatelessWidget {
  final String   title;
  final String   content;
  final String   confirmLabel;
  final String   cancelLabel;
  final Color?   confirmColor;
  final bool     isDangerous;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmLabel = 'Xác nhận',
    this.cancelLabel  = 'Hủy',
    this.confirmColor,
    this.isDangerous  = false,
  });

  /// Hiện dialog và trả về true nếu user nhấn Xác nhận
  static Future<bool> show(
      BuildContext context, {
        required String title,
        required String content,
        String  confirmLabel = 'Xác nhận',
        String  cancelLabel  = 'Hủy',
        bool    isDangerous  = false,
        Color?  confirmColor,
      }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ConfirmDialog(
        title:        title,
        content:      content,
        confirmLabel: confirmLabel,
        cancelLabel:  cancelLabel,
        isDangerous:  isDangerous,
        confirmColor: confirmColor,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final actionColor = confirmColor ??
        (isDangerous ? AppColors.statusOverdue : AppColors.primary);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceXXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title ─────────────────────────────────────────
            Text(title, style: AppTextStyles.headlineSmall),
            const SizedBox(height: AppDimensions.spaceMD),

            // ── Content ───────────────────────────────────────
            Text(
              content,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey600,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceXXL),

            // ── Actions ───────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.grey300),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMD),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.spaceMD,
                      ),
                    ),
                    child: Text(
                      cancelLabel,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.spaceMD),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: actionColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMD),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.spaceMD,
                      ),
                    ),
                    child: Text(confirmLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}