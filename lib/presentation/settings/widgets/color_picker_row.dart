import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class ColorPickerRow extends StatelessWidget {
  final Color                selected;
  final ValueChanged<Color>  onChanged;

  const ColorPickerRow({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  // ── Preset colors ─────────────────────────────────────────────
  static const _presets = [
    Color(0xFFE8344E), // Đỏ Tết (mặc định)
    Color(0xFFF5A623), // Vàng may mắn
    Color(0xFF4CAF50), // Xanh lá bình an
    Color(0xFF7C5CBF), // Tím thịnh vượng
    Color(0xFF2196F3), // Xanh dương
    Color(0xFFFF7043), // Cam ấm áp
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLG,
        vertical:   AppDimensions.spaceMD,
      ),
      child: Row(
        children: [
          // ── Icon ─────────────────────────────────────────────
          Container(
            width:  40,
            height: 40,
            decoration: BoxDecoration(
              color:        AppColors.accent.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
            ),
            child: const Icon(
              Icons.palette_outlined,
              color: AppColors.accent,
              size:  AppDimensions.iconMD,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMD),

          // ── Label ─────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Màu chủ đạo',
                  style: AppTextStyles.titleMedium,
                ),
                Text(
                  'Thay đổi màu sắc thường',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),

          // ── Color swatches ────────────────────────────────────
          Row(
            children: _presets.map((color) {
              final isSelected = selected.value == color.value;
              return GestureDetector(
                onTap: () => onChanged(color),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(left: AppDimensions.spaceXS),
                  width:  isSelected ? 28 : 22,
                  height: isSelected ? 28 : 22,
                  decoration: BoxDecoration(
                    color:  color,
                    shape:  BoxShape.circle,
                    border: isSelected
                        ? Border.all(
                      color: AppColors.white,
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    )
                        : null,
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color:      color.withValues(alpha:0.5),
                        blurRadius: 6,
                        offset:     const Offset(0, 2),
                      ),
                    ]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(
                    Icons.check_rounded,
                    color: AppColors.white,
                    size:  14,
                  )
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}