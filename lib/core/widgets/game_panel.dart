import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GamePanel extends StatelessWidget {
  const GamePanel({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(18),
    this.borderColor,
    this.gradient,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final Gradient? gradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      decoration: BoxDecoration(
        color: gradient == null ? AppColors.panel : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor ?? AppColors.borderSoft),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: content,
      ),
    );
  }
}
