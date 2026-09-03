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
          colors: [Color(0xFF0E1B39), Color(0xFF070F1D), AppColors.background],
          stops: [0, 0.4, 0.9],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _SceneGridPainter()),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _SceneGridPainter extends CustomPainter {
  const _SceneGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withOpacity(0.03);

    const step = 36.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final purpleGlow = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 42)
      ..color = AppColors.purple.withOpacity(0.08);
    canvas.drawCircle(Offset(size.width * 0.80, size.height * 0.12), 120, purpleGlow);

    final blueGlow = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 48)
      ..color = AppColors.blue.withOpacity(0.06);
    canvas.drawCircle(Offset(size.width * 0.20, size.height * 0.75), 110, blueGlow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
