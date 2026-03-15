import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProgressSlider extends StatelessWidget {
  final int               value;    // 0 → 100
  final ValueChanged<int> onChanged;

  const ProgressSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary; // FIX

    return Column(
      children: [
        // ── Labels ────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('BẮT ĐẦU',  style: AppTextStyles.labelSmall),
            Text('ĐANG LÀM', style: AppTextStyles.labelSmall),
            Text('XONG',     style: AppTextStyles.labelSmall),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceXS),

        // ── Slider ────────────────────────────────────────────
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor:   primary,
            inactiveTrackColor: AppColors.grey200,
            thumbColor:         primary,
            overlayColor:       primary.withValues(alpha: 0.15),
            trackHeight:        4,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 10,
            ),
          ),
          child: Slider(
            value:     value.toDouble(),
            min:       0,
            max:       100,
            divisions: 20,
            label:     '$value%',
            onChanged: (v) => onChanged(v.round()),
          ),
        ),

        // ── Percent display ───────────────────────────────────
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceLG,
              vertical:   AppDimensions.spaceXS,
            ),
            decoration: BoxDecoration(
              color:        primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Text(
              '$value%',
              style: AppTextStyles.titleMedium.copyWith(color: primary),
            ),
          ),
        ),
      ],
    );
  }
}