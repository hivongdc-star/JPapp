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
    final panel = Container(
      decoration: BoxDecoration(
        color: gradient == null ? AppColors.panel : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor ?? AppColors.borderSoft),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.12),
                    Colors.white.withOpacity(0.02),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
              ),
            ),
          ),
          Padding(padding: padding, child: child),
        ],
      ),
    );

    if (onTap == null) {
      return panel;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: panel,
      ),
    );
  }
}
