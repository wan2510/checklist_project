import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class AppProgressBar extends StatelessWidget {
  final double value;        // 0.0 → 1.0
  final double? height;
  final Color?  fillColor;
  final Color?  backgroundColor;
  final bool    animated;
  final double? borderRadius;

  const AppProgressBar({
    super.key,
    required this.value,
    this.height,
    this.fillColor,
    this.backgroundColor,
    this.animated     = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, 1.0);
    final barHeight    = height ?? AppDimensions.progressBarHeight;
    final radius       = borderRadius ?? AppDimensions.radiusFull;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: barHeight,
        color:  backgroundColor ?? AppColors.progressBackground,
        child: animated
            ? TweenAnimationBuilder<double>(
          tween:    Tween(begin: 0, end: clampedValue),
          duration: const Duration(milliseconds: 600),
          curve:    Curves.easeInOut,
          builder:  (_, animValue, __) =>
              _buildFill(animValue, barHeight, radius),
        )
            : _buildFill(clampedValue, barHeight, radius),
      ),
    );
  }

  Widget _buildFill(double val, double barHeight, double radius) {
    return FractionallySizedBox(
      widthFactor: val,
      child: Container(
        height:     barHeight,
        decoration: BoxDecoration(
          color: _resolveColor(val),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  /// Đổi màu tự động theo tiến độ nếu không truyền fillColor
  Color _resolveColor(double val) {
    if (fillColor != null) return fillColor!;
    if (val >= 1.0)  return AppColors.statusDone;
    if (val >= 0.5)  return AppColors.primary;
    return AppColors.primary;
  }
}