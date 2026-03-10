import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Card wrapper dùng chung — tự động áp dụng shadow + border radius
class AppCard extends StatelessWidget {
  final Widget      child;
  final EdgeInsets? padding;
  final Color?      color;
  final VoidCallback? onTap;
  final double?     borderRadius;
  final Border?     border;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(AppDimensions.spaceLG),
        decoration: BoxDecoration(
          color:        color ?? AppColors.white,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimensions.radiusLG,
          ),
          border: border,
          boxShadow: [
            BoxShadow(
              color:      AppColors.grey400.withOpacity(0.12),
              blurRadius: 8,
              offset:     const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}