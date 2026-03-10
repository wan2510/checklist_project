import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String        title;
  final List<Widget>? actions;
  final Widget?       leading;
  final bool          showBack;
  final Color?        backgroundColor;
  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBack       = true,
    this.backgroundColor,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.white,
      elevation:       0,
      centerTitle:     false,
      leading: showBack
          ? IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: AppDimensions.iconMD,
        ),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      )
          : leading,
      automaticallyImplyLeading: showBack,
      title: Text(title, style: AppTextStyles.headlineSmall),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColors.grey200,
        ),
      ),
    );
  }
}