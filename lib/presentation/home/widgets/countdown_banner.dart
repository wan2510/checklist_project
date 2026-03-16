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

    // FIX: dùng theme primary, tạo 3 điểm gradient đậm → vừa → tối
    final primary     = Theme.of(context).colorScheme.primary;
    final primaryDark = Color.lerp(primary, Colors.black, 0.30)!;   // 30% tối hơn
    final primaryMid  = Color.lerp(primary, Colors.black, 0.10)!;   // 10% tối hơn

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            // FIX: shadow đậm hơn
            color:        primary.withValues(alpha: 0.55),
            blurRadius:   24,
            offset:       const Offset(0, 10),
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        child: Stack(
          children: [
            // ── Gradient background — 3 điểm đậm hơn ─────────
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryDark, primary, primaryMid],
                  stops:  const [0.0, 0.55, 1.0],
                  begin:  Alignment.topLeft,
                  end:    Alignment.bottomRight,
                ),
              ),
            ),

            // ── Lớp overlay tối ở góc dưới phải ──────────────
            // FIX: thêm overlay để không bị "trắng bệch"
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.18),
                    ],
                    begin: Alignment.topLeft,
                    end:   Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            // ── Decorative circles — tăng opacity ────────────
            Positioned(
              top:   -30,
              right: -20,
              child: Container(
                width:  130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // FIX: 0.07 → 0.18
                  color: Colors.white.withValues(alpha: 0.18),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left:   -20,
              child: Container(
                width:  150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // FIX: 0.05 → 0.12
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
            ),
            // FIX: thêm circle thứ 3 ở giữa phải
            Positioned(
              top:   60,
              right: -30,
              child: Container(
                width:  90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),

            // ── Confetti dots ─────────────────────────────────
            Positioned(
              bottom: 14,
              right:  80,
              child: Container(
                width: 7, height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // FIX: 0.6 → 0.85
                  color: const Color(0xFFF2C94C).withValues(alpha: 0.85),
                ),
              ),
            ),
            Positioned(
              top:   18,
              right: 130,
              child: Container(
                width: 5, height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // FIX: 0.4 → 0.65
                  color: Colors.white.withValues(alpha: 0.65),
                ),
              ),
            ),
            // FIX: thêm dot thứ 3
            Positioned(
              top:  45,
              left: 80,
              child: Container(
                width: 4, height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ),

            // ── Content ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceXXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Top row: badge + animal ──────────────────
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          // FIX: 0.2 → 0.28
                          color:        Colors.white.withValues(alpha: 0.28),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.cleaning_services_rounded,
                                size: 11, color: Colors.white),
                            const SizedBox(width: 4),
                            const Text(
                              'Sẵn sàng đón Tết',
                              style: TextStyle(
                                color:      Colors.white,
                                fontSize:   10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 46, height: 46,
                        decoration: BoxDecoration(
                          // FIX: 0.15 → 0.25
                          color:        Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.45),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(animal,
                              style: const TextStyle(fontSize: 24)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.spaceSM),

                  Text(
                    tetTitle,
                    style: const TextStyle(
                      color:         Colors.white,
                      fontSize:      16,
                      fontWeight:    FontWeight.w800,
                      letterSpacing: -0.3,
                      // FIX: thêm shadow nhẹ cho chữ
                      shadows: [
                        Shadow(
                          color:  Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimensions.spaceSM),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Còn ', style: AppTextStyles.countdownLabel),
                      Text('$daysLeft', style: AppTextStyles.countdownNumber),
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

                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value:           progress,
                            minHeight:       5, // FIX: dày hơn
                            backgroundColor: Colors.white.withValues(alpha: 0.30),
                            valueColor: const AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(progress * 100).round()}% Năm cũ',
                        style: TextStyle(
                          color:      Colors.white.withValues(alpha: 0.90),
                          fontSize:   10,
                          fontWeight: FontWeight.w500,
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