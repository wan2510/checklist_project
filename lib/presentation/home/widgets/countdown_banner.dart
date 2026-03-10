import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/tet_date_utils.dart';

class CountdownBanner extends StatelessWidget {
  final int daysLeft;

  const CountdownBanner({super.key, required this.daysLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceXXL),
      decoration: BoxDecoration(
        gradient:     AppColors.bannerGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color:      AppColors.primary.withValues(alpha:0.3),
            blurRadius: 16,
            offset:     const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Left: text ──────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sẵn sàng đón ${TetDateUtils.tetName}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color:   AppColors.white.withValues(alpha:0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXS),

                // ── Countdown number ────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Còn ',
                      style: AppTextStyles.countdownLabel,
                    ),
                    Text(
                      '$daysLeft',
                      style: AppTextStyles.countdownNumber,
                    ),
                    const SizedBox(width: AppDimensions.spaceXS),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        'Ngày',
                        style: AppTextStyles.countdownLabel.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceXS),

                Text(
                  'Đừng quên dọn dẹp nhà cửa nhé!',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white.withValues(alpha:0.75),
                  ),
                ),
              ],
            ),
          ),

          // ── Right: icon ─────────────────────────────────────
          Container(
            width:  56,
            height: 56,
            decoration: BoxDecoration(
              color:        AppColors.white.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            ),
            child: const Center(
              child: Text('🏮', style: TextStyle(fontSize: 28)),
            ),
          ),
        ],
      ),
    );
  }
}