import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/game_panel.dart';
import '../../core/widgets/scene_scaffold.dart';

class RoadmapScene extends StatefulWidget {
  const RoadmapScene({super.key});

  @override
  State<RoadmapScene> createState() => _RoadmapSceneState();
}

class _RoadmapSceneState extends State<RoadmapScene> {
  final ScrollController _scrollController = ScrollController();
  int _levelIndex = 2;

  static const _nodes = [
    _MapNode(1, 0.19, 0.88, '01 〜ことができる', NodeState.cleared),
    _MapNode(2, 0.28, 0.75, '02 〜つもりだ', NodeState.cleared),
    _MapNode(3, 0.35, 0.61, '03 〜ことになっている', NodeState.current),
    _MapNode(4, 0.62, 0.53, '04 〜でなく', NodeState.available),
    _MapNode(5, 0.64, 0.37, '05 〜ようにする', NodeState.available),
    _MapNode(6, 0.57, 0.25, '06 〜かもしれない', NodeState.locked),
    _MapNode(7, 0.43, 0.12, '07 〜わけではない', NodeState.locked),
    _MapNode(8, 0.77, 0.23, 'Test Bài 04', NodeState.boss),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent * 0.34);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SceneScaffold(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      child: Column(
        children: [
          _RoadmapTopBar(
            levelIndex: _levelIndex,
            onLevelChanged: (index) => setState(() => _levelIndex = index),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final canvasWidth = math.min(constraints.maxWidth, 920.0);
                const canvasHeight = 1180.0;
                final sideOffset = math.max((constraints.maxWidth - canvasWidth) / 2 - 8, 12.0);

                return SingleChildScrollView(
                  controller: _scrollController,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: canvasWidth,
                      height: canvasHeight,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: const ColoredBox(color: AppColors.panel),
                            ),
                          ),
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: const CustomPaint(painter: _RoadmapBackdropPainter()),
                            ),
                          ),
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    AppColors.background.withOpacity(0.06),
                                    AppColors.background.withOpacity(0.24),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: CustomPaint(painter: _RoadPainter(nodes: _nodes)),
                          ),
                          ..._nodes.map((node) {
                            final left = node.x * canvasWidth - 54;
                            final top = node.y * canvasHeight - 38;
                            return Positioned(
                              left: left,
                              top: top,
                              child: _RoadNodeWidget(
                                node: node,
                                onTap: () => _showNodeDetails(context, node),
                              ),
                            );
                          }),
                          Positioned(
                            left: 28,
                            top: canvasHeight * 0.57,
                            child: _SpecialRoadNode(
                              title: 'TEST',
                              subtitle: 'Test Chương',
                              icon: Icons.assignment_rounded,
                              color: AppColors.gold,
                              onTap: () => _showAuxiliaryNode(context, 'Test Chương'),
                            ),
                          ),
                          Positioned(
                            left: canvasWidth * 0.72,
                            top: canvasHeight * 0.24,
                            child: _SpecialRoadNode(
                              title: 'BOSS',
                              subtitle: 'Test Bài 04',
                              icon: Icons.shield_moon_rounded,
                              color: AppColors.gold,
                              onTap: () => _showAuxiliaryNode(context, 'Test Bài 04'),
                            ),
                          ),
                          _PlayerMarker(
                            x: _nodes[2].x * canvasWidth,
                            y: _nodes[2].y * canvasHeight,
                          ),
                          Positioned(
                            top: 18,
                            right: sideOffset,
                            child: _LevelRail(
                              selectedIndex: _levelIndex,
                              onSelect: (index) => setState(() => _levelIndex = index),
                            ),
                          ),
                          const Positioned(
                            left: 18,
                            right: 18,
                            bottom: 18,
                            child: _ProgressHud(progress: 0.58),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showNodeDetails(BuildContext context, _MapNode node) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.panel,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chương ${node.id.toString().padLeft(2, '0')}',
                style: const TextStyle(color: AppColors.cyan, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(node.label, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              Text(_nodeDescription(node.state)),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: node.state == NodeState.locked ? null : () => Navigator.pop(context),
                  child: Text(
                    node.state == NodeState.current
                        ? 'TIẾP TỤC'
                        : node.state == NodeState.locked
                            ? 'CHƯA MỞ KHÓA'
                            : 'XEM CHI TIẾT',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAuxiliaryNode(BuildContext context, String title) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.panel,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              const Text('Đây là mốc đánh giá tổng hợp, không có trợ giúp, không hiện lý thuyết giữa bài.'),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text('ĐÓNG')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoadmapTopBar extends StatelessWidget {
  const _RoadmapTopBar({required this.levelIndex, required this.onLevelChanged});

  final int levelIndex;
  final ValueChanged<int> onLevelChanged;

  static const levels = ['N5', 'N4', 'N3', 'N2', 'N1'];

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          _TopBarButton(icon: Icons.chevron_left_rounded, onTap: () {}),
          const SizedBox(width: 12),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(colors: [AppColors.purple, AppColors.blue]),
            ),
            alignment: Alignment.center,
            child: Text(levels[levelIndex], style: const TextStyle(fontWeight: FontWeight.w900)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bài 04: 表現の幅を広げる', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                SizedBox(height: 2),
                Text('Hành trình N3 • 58% hoàn thành', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
          _TopBarButton(icon: Icons.grid_view_rounded, label: 'Xem tổng quan', onTap: () {}),
        ],
      ),
    );
  }
}

class _TopBarButton extends StatelessWidget {
  const _TopBarButton({required this.icon, required this.onTap, this.label});

  final IconData icon;
  final VoidCallback onTap;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: label == null ? 10 : 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.backgroundRaised.withOpacity(0.86),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.textMuted),
            if (label != null) ...[
              const SizedBox(width: 8),
              Text(label!, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }
}

class _RoadNodeWidget extends StatelessWidget {
  const _RoadNodeWidget({required this.node, required this.onTap});

  final _MapNode node;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color ringColor;
    final Color labelColor;
    final IconData icon;
    switch (node.state) {
      case NodeState.cleared:
        ringColor = AppColors.green;
        labelColor = AppColors.green;
        icon = Icons.check_rounded;
      case NodeState.current:
        ringColor = AppColors.purpleBright;
        labelColor = AppColors.purpleBright;
        icon = Icons.menu_book_rounded;
      case NodeState.available:
        ringColor = AppColors.blue;
        labelColor = AppColors.cyan;
        icon = Icons.circle_outlined;
      case NodeState.locked:
        ringColor = AppColors.textDim;
        labelColor = AppColors.textMuted;
        icon = Icons.lock_rounded;
      case NodeState.boss:
        ringColor = AppColors.gold;
        labelColor = AppColors.gold;
        icon = Icons.emoji_events_rounded;
    }

    final size = node.state == NodeState.boss ? 82.0 : 72.0;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.backgroundRaised.withOpacity(0.92),
              border: Border.all(color: ringColor, width: node.state == NodeState.current ? 4 : 3),
              boxShadow: [BoxShadow(color: ringColor.withOpacity(0.32), blurRadius: node.state == NodeState.current ? 22 : 14)],
            ),
            alignment: Alignment.center,
            child: node.state == NodeState.available
                ? Text(
                    node.id.toString().padLeft(2, '0'),
                    style: TextStyle(color: ringColor, fontSize: 24, fontWeight: FontWeight.w900),
                  )
                : Icon(icon, color: ringColor, size: node.state == NodeState.boss ? 36 : 28),
          ),
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxWidth: 172),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.76),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSoft),
            ),
            child: Text(
              node.label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: labelColor, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecialRoadNode extends StatelessWidget {
  const _SpecialRoadNode({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(colors: [Color(0xFF382416), Color(0xFF121010)]),
              border: Border.all(color: color, width: 3),
              boxShadow: [BoxShadow(color: color.withOpacity(0.30), blurRadius: 24)],
            ),
            child: Icon(icon, color: color, size: 34),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.80),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSoft),
            ),
            child: Column(
              children: [
                Text(title, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerMarker extends StatelessWidget {
  const _PlayerMarker({required this.x, required this.y});

  final double x;
  final double y;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x - 26,
      top: y - 120,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [Color(0xFF332C67), Color(0xFF0B1223)]),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [BoxShadow(color: Color(0x668754FF), blurRadius: 24)],
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 30),
          ),
          Container(width: 4, height: 18, color: AppColors.purpleBright),
          Container(
            width: 58,
            height: 16,
            decoration: BoxDecoration(color: AppColors.purple.withOpacity(0.32), borderRadius: BorderRadius.circular(999)),
          ),
        ],
      ),
    );
  }
}

class _LevelRail extends StatelessWidget {
  const _LevelRail({required this.selectedIndex, required this.onSelect});

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const levels = ['N5', 'N4', 'N3', 'N2', 'N1'];

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(levels.length, (index) {
          final selected = selectedIndex == index;
          return Padding(
            padding: EdgeInsets.only(bottom: index == levels.length - 1 ? 0 : 8),
            child: InkWell(
              onTap: () => onSelect(index),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 50,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? AppColors.blue.withOpacity(0.16) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selected ? AppColors.blue : AppColors.borderSoft),
                ),
                alignment: Alignment.center,
                child: Text(
                  levels[index],
                  style: TextStyle(
                    color: selected ? AppColors.cyan : AppColors.textMuted,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ProgressHud extends StatelessWidget {
  const _ProgressHud({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tiến độ bài', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(999)),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    color: AppColors.blue,
                    backgroundColor: AppColors.borderSoft,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text('${(progress * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(width: 16),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gold.withOpacity(0.45)),
            ),
            child: const Icon(Icons.inventory_2_rounded, color: AppColors.gold),
          ),
        ],
      ),
    );
  }
}

class _RoadPainter extends CustomPainter {
  _RoadPainter({required this.nodes});

  final List<_MapNode> nodes;

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.length < 2) {
      return;
    }

    final points = nodes.map((node) => Offset(node.x * size.width, node.y * size.height)).toList(growable: false);
    final path = Path()..moveTo(points.first.dx, points.first.dy);

    for (var index = 1; index < points.length; index++) {
      final previous = points[index - 1];
      final current = points[index];
      final midY = (previous.dy + current.dy) / 2;
      path.cubicTo(previous.dx, midY, current.dx, midY, current.dx, current.dy);
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round
        ..color = AppColors.background.withOpacity(0.55),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..color = Colors.white.withOpacity(0.78),
    );

    final dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF8AD7FF);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 12), dashPaint);
        distance += 24;
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18)
        ..color = AppColors.purple.withOpacity(0.22),
    );
  }

  @override
  bool shouldRepaint(covariant _RoadPainter oldDelegate) => false;
}

class _RoadmapBackdropPainter extends CustomPainter {
  const _RoadmapBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF223B6E), Color(0xFF182446), Color(0xFF0B1120)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);

    final moonPaint = Paint()..color = const Color(0xFFFFD9B6).withOpacity(0.50);
    canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.12), size.width * 0.06, moonPaint);

    _drawMountainLayer(canvas, size, const Color(0xFF13254A), 0.25, 0.10);
    _drawMountainLayer(canvas, size, const Color(0xFF101D39), 0.34, 0.13);
    _drawMountainLayer(canvas, size, const Color(0xFF0A1324), 0.47, 0.18);

    _drawCastle(canvas, Offset(size.width * 0.70, size.height * 0.14), 1.0);
    _drawCastle(canvas, Offset(size.width * 0.60, size.height * 0.17), 0.82);

    final river = Path()
      ..moveTo(size.width * 0.18, size.height)
      ..cubicTo(size.width * 0.28, size.height * 0.82, size.width * 0.58, size.height * 0.76, size.width * 0.72, size.height * 0.54)
      ..cubicTo(size.width * 0.82, size.height * 0.42, size.width * 0.84, size.height * 0.32, size.width * 0.76, size.height * 0.18)
      ..lineTo(size.width, size.height * 0.20)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(
      river,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3F8FFF), Color(0xFF153058), Color(0xFF102846)],
        ).createShader(Rect.fromLTWH(size.width * 0.16, size.height * 0.18, size.width * 0.84, size.height * 0.82)),
    );

    final blossomPaint = Paint()..color = const Color(0xFFF18ED1).withOpacity(0.36);
    final trunkPaint = Paint()..color = const Color(0xFF261A25);
    _drawTree(canvas, Offset(size.width * 0.16, size.height * 0.28), 1.0, blossomPaint, trunkPaint);
    _drawTree(canvas, Offset(size.width * 0.12, size.height * 0.58), 1.2, blossomPaint, trunkPaint);
    _drawTree(canvas, Offset(size.width * 0.87, size.height * 0.23), 0.9, blossomPaint, trunkPaint);
    _drawTree(canvas, Offset(size.width * 0.88, size.height * 0.52), 1.1, blossomPaint, trunkPaint);

    final stars = Paint()..color = Colors.white.withOpacity(0.55);
    for (var index = 0; index < 48; index++) {
      final x = ((index * 73) % 997) / 997 * size.width;
      final y = ((index * 53) % 263) / 263 * size.height * 0.26;
      canvas.drawCircle(Offset(x, y), index % 8 == 0 ? 1.4 : 0.8, stars);
    }
  }

  void _drawMountainLayer(Canvas canvas, Size size, Color color, double baseY, double variance) {
    final path = Path()..moveTo(0, size.height * baseY);
    const peaks = 7;
    for (var index = 0; index <= peaks; index++) {
      final x = size.width * index / peaks;
      final y = size.height * (baseY - (index.isEven ? variance : variance * 0.35));
      path.lineTo(x, y);
    }
    path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawCastle(Canvas canvas, Offset origin, double scale) {
    final paint = Paint()..color = const Color(0xFF0A1324);
    final highlight = Paint()..color = const Color(0xFF20335C);

    Rect body(double x, double y, double width, double height) => Rect.fromLTWH(
          origin.dx + x * scale,
          origin.dy + y * scale,
          width * scale,
          height * scale,
        );

    canvas.drawRect(body(-12, 46, 70, 76), paint);
    canvas.drawRect(body(8, 22, 30, 48), highlight);
    canvas.drawRect(body(16, -4, 14, 32), highlight);
    canvas.drawRect(body(-2, 18, 18, 30), paint);
    canvas.drawRect(body(30, 18, 18, 30), paint);
    canvas.drawRect(body(-24, 56, 16, 46), paint);
    canvas.drawRect(body(56, 56, 16, 46), paint);
  }

  void _drawTree(Canvas canvas, Offset origin, double scale, Paint blossomPaint, Paint trunkPaint) {
    canvas.drawRect(Rect.fromLTWH(origin.dx, origin.dy, 8 * scale, 44 * scale), trunkPaint);
    for (var index = 0; index < 18; index++) {
      final dx = origin.dx - 20 * scale + (index * 11 % 44) * scale;
      final dy = origin.dy - 28 * scale + (index * 7 % 36) * scale;
      canvas.drawCircle(Offset(dx, dy), (8 + index % 5) * scale, blossomPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapNode {
  const _MapNode(this.id, this.x, this.y, this.label, this.state);

  final int id;
  final double x;
  final double y;
  final String label;
  final NodeState state;
}

enum NodeState { cleared, current, available, locked, boss }

String _nodeDescription(NodeState state) {
  switch (state) {
    case NodeState.cleared:
      return 'Chương này đã hoàn thành và đã được tính vào tiến độ của bài.';
    case NodeState.current:
      return 'Đây là chương hiện tại. Bạn có thể tiếp tục học, làm bài luyện và kiểm tra chương.';
    case NodeState.available:
      return 'Chương này đã mở khóa. Bạn có thể vào xem chi tiết và bắt đầu học bất cứ lúc nào.';
    case NodeState.locked:
      return 'Chương này chưa mở khóa. Hãy hoàn thành các mốc trước để tiếp tục hành trình.';
    case NodeState.boss:
      return 'Đây là bài kiểm tra lớn cuối bài. Cần vượt qua để hoàn tất Bài 04.';
  }
}
