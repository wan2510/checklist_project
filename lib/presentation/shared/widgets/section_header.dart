import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String    title;
  final String?   actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
      final primary = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(
            color: context.textPrimary, // FIX: dark mode → trắng
          ),
        ),
        if (actionLabel != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: AppTextStyles.labelMedium.copyWith(
                color: primary, // FIX: theo theme
              ),
            ),
          ),
      ],
    );
  }
}