import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class SettingsSection extends StatelessWidget {
  final String        title;
  final List<Widget>  children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section title ──────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(
            left:   AppDimensions.spaceXS,
            bottom: AppDimensions.spaceSM,
          ),
          child: Text(
            title,
            style: AppTextStyles.titleSmall.copyWith(
              color:         AppColors.grey500,
              letterSpacing: 0.8,
            ),
          ),
        ),

        // ── Items container ────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color:        AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            boxShadow: [
              BoxShadow(
                color:      AppColors.grey300.withValues(alpha:0.3),
                blurRadius: 8,
                offset:     const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children.asMap().entries.map((entry) {
              final index = entry.key;
              final child = entry.value;
              final isLast = index == children.length - 1;

              return Column(
                children: [
                  child,
                  if (!isLast)
                    const Divider(
                      height:  1,
                      indent:  AppDimensions.spaceLG + AppDimensions.iconXL,
                      endIndent: AppDimensions.spaceLG,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Standard settings tile ────────────────────────────────────
class SettingsTile extends StatelessWidget {
  final IconData  icon;
  final Color     iconColor;
  final Color     iconBgColor;
  final String    title;
  final String?   subtitle;
  final Widget?   trailing;
  final VoidCallback? onTap;
  final bool      isDanger;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:        onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceLG,
          vertical:   AppDimensions.spaceMD,
        ),
        child: Row(
          children: [
            // ── Icon ──────────────────────────────────────────
            Container(
              width:  40,
              height: 40,
              decoration: BoxDecoration(
                color:        iconBgColor,
                borderRadius: BorderRadius.circular(
                  AppDimensions.radiusSM,
                ),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size:  AppDimensions.iconMD,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceMD),

            // ── Labels ────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: isDanger
                          ? AppColors.statusOverdue
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ── Trailing ──────────────────────────────────────
            if (trailing != null) trailing!
            else if (onTap != null)
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.grey400,
                size:  AppDimensions.iconMD,
              ),
          ],
        ),
      ),
    );
  }
}

// ── Toggle tile ───────────────────────────────────────────────
class SettingsToggleTile extends StatelessWidget {
  final IconData  icon;
  final Color     iconColor;
  final Color     iconBgColor;
  final String    title;
  final String?   subtitle;
  final bool      value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon:       icon,
      iconColor:  iconColor,
      iconBgColor: iconBgColor,
      title:      title,
      subtitle:   subtitle,
      trailing: Switch(
        value:     value,
        onChanged: onChanged,
      ),
    );
  }
}