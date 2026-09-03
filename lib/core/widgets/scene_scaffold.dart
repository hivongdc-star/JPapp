import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SceneScaffold extends StatelessWidget {
  const SceneScaffold({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 24),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.2,
          colors: [Color(0xFF101C3B), AppColors.background],
          stops: [0, 0.68],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
