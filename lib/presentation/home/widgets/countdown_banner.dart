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
    final tetTitle = TetDateUtils.tetFullTitle;
    final animal   = TetDateUtils.tetAnimal;
    final progress = TetDateUtils.timeElapsedPercent;

    // FIX: Lấy màu chủ đề hiện tại thay vì hardcode đỏ
    final primary      = Theme.of(context).colorScheme.primary;
    final primaryLight = Color.lerp(primary, Colors.white, 0.25)!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color:        primary.withValues(alpha: 0.35),
            blurRadius:   20,
            offset:       const Offset(0, 8),
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        child: Stack(
          children: [
            // ── Gradient background (theo theme) ────────────────
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary, primaryLight],
                  begin:  Alignment.topLeft,
                  end:    Alignment.bottomRight,
                ),
              ),
            ),

            // ── Decorative circles ───────────────────────────────
            Positioned(
              top:   -30,
              right: -20,
              child: Container(
                width:  120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left:   -20,
              child: Container(
                width:  140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),

            // ── Confetti dots ─────────────────────────────────────
            Positioned(
              bottom: 14,
              right:  80,
              child: Container(
                width:  6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF2C94C).withValues(alpha: 0.6),
                ),
              ),
            ),
            Positioned(
              top:   18,
              right: 130,
              child: Container(
                width:  4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ),

            // ── Content ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceXXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Top row: badge + animal ─────────────────
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical:   3,
                        ),
                        decoration: BoxDecoration(
                          color:        Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.cleaning_services_rounded,
                              size:  11,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Sẵn sàng đón Tết',
                              style: TextStyle(
                                color:      Colors.white.withValues(alpha: 0.9),
                                fontSize:   10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Animal icon
                      Container(
                        width:  46,
                        height: 46,
                        decoration: BoxDecoration(
                          color:        Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            animal,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.spaceSM),

                  // ── Tet title ─────────────────────────────────
                  Text(
                    tetTitle,
                    style: const TextStyle(
                      color:         Colors.white,
                      fontSize:      16,
                      fontWeight:    FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.spaceSM),

                  // ── Countdown number ──────────────────────────
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          ' Ngày',
                          style: AppTextStyles.countdownLabel.copyWith(
                            fontSize:   18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.spaceMD),

                  // ── Progress bar ──────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value:           progress,
                            minHeight:       4,
                            backgroundColor: Colors.white.withValues(alpha: 0.25),
                            valueColor: const AlwaysStoppedAnimation(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(progress * 100).round()}% Năm cũ',
                        style: TextStyle(
                          color:    Colors.white.withValues(alpha: 0.75),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}