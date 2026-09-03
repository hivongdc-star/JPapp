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
    _MapNode(1, 0.22, 0.87, '〜ことができる', NodeState.cleared),
    _MapNode(2, 0.50, 0.75, '〜つもりだ', NodeState.cleared),
    _MapNode(3, 0.31, 0.62, '〜ことになっている', NodeState.current),
    _MapNode(4, 0.64, 0.53, '〜ておく', NodeState.available),
    _MapNode(5, 0.78, 0.42, '〜ようにする', NodeState.available),
    _MapNode(6, 0.53, 0.31, '〜かもしれない', NodeState.locked),
    _MapNode(7, 0.35, 0.20, '〜わけではない', NodeState.locked),
    _MapNode(8, 0.70, 0.10, 'Test Bài 04', NodeState.boss),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent * 0.42);
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
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _RoadmapHeader(
            levelIndex: _levelIndex,
            onLevelChanged: (value) => setState(() => _levelIndex = value),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final canvasWidth = math.min(constraints.maxWidth, 920.0);
                const canvasHeight = 1380.0;

                return SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: canvasWidth,
                      height: canvasHeight,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(painter: _JourneyBackgroundPainter()),
                          ),
                          Positioned.fill(
                            child: CustomPaint(painter: _RoadPainter(nodes: _nodes)),
                          ),
                          ..._nodes.map((node) {
                            final x = node.x * canvasWidth;
                            final y = node.y * canvasHeight;
                            return Positioned(
                              left: x - 42,
                              top: y - 42,
                              child: _RoadNodeWidget(node: node, onTap: () => _showNodeDetails(context, node)),
                            );
                          }),
                          _PlayerMarker(
                            x: _nodes[2].x * canvasWidth,
                            y: _nodes[2].y * canvasHeight,
                          ),
                          Positioned(
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
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chương ${node.id.toString().padLeft(2, '0')}', style: const TextStyle(color: AppColors.cyan, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(node.label, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Text(_nodeDescription(node.state)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: node.state == NodeState.locked ? null : () => Navigator.pop(context),
                  child: Text(node.state == NodeState.current ? 'TIẾP TỤC' : node.state == NodeState.locked ? 'CHƯA MỞ KHÓA' : 'XEM CHI TIẾT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoadmapHeader extends StatelessWidget {
  const _RoadmapHeader({required this.levelIndex, required this.onLevelChanged});

  final int levelIndex;
  final ValueChanged<int> onLevelChanged;

  static const levels = ['N5', 'N4', 'N3', 'N2', 'N1'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
      decoration: const BoxDecoration(
        color: AppColors.backgroundRaised,
        border: Border(bottom: BorderSide(color: AppColors.borderSoft)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
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
                Text('Bài 04: 意見の幅を広げる', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                SizedBox(height: 3),
                Text('Hành trình N3 • 58% hoàn thành', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
          PopupMenuButton<int>(
            tooltip: 'Chọn cấp JLPT',
            onSelected: onLevelChanged,
            itemBuilder: (context) => List.generate(
              levels.length,
              (index) => PopupMenuItem(value: index, child: Text(levels[index])),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(color: AppColors.panel, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
              child: const Row(children: [Text('Cấp độ'), SizedBox(width: 6), Icon(Icons.expand_more_rounded, size: 18)]),
            ),
          ),
        ],
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
    final (color, icon) = switch (node.state) {
      NodeState.cleared => (AppColors.green, Icons.check_rounded),
      NodeState.current => (AppColors.purpleBright, Icons.menu_book_rounded),
      NodeState.available => (AppColors.cyan, Icons.circle_outlined),
      NodeState.locked => (AppColors.textDim, Icons.lock_rounded),
      NodeState.boss => (AppColors.gold, Icons.emoji_events_rounded),
    };

    return Semantics(
      button: true,
      label: 'Chương ${node.id}: ${node.label}',
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: node.state == NodeState.boss ? 72 : 60,
              height: node.state == NodeState.boss ? 72 : 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.backgroundRaised,
                border: Border.all(color: color, width: node.state == NodeState.current ? 4 : 3),
                boxShadow: [
                  BoxShadow(color: color.withOpacity(node.state == NodeState.locked ? 0.08 : 0.35), blurRadius: node.state == NodeState.current ? 28 : 14, spreadRadius: 1),
                ],
              ),
              alignment: Alignment.center,
              child: node.state == NodeState.available
                  ? Text(node.id.toString().padLeft(2, '0'), style: TextStyle(color: color, fontWeight: FontWeight.w900))
                  : Icon(icon, color: color, size: node.state == NodeState.boss ? 32 : 24),
            ),
            const SizedBox(height: 6),
            Container(
              constraints: const BoxConstraints(maxWidth: 150),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(color: AppColors.background.withOpacity(0.88), borderRadius: BorderRadius.circular(9), border: Border.all(color: AppColors.borderSoft)),
              child: Text(node.label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
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
      left: x - 24,
      top: y - 104,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [AppColors.purple, AppColors.blue]),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [BoxShadow(color: Color(0x998754FF), blurRadius: 24)],
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 31),
          ),
          Container(width: 3, height: 13, color: AppColors.purpleBright),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.route_rounded, color: AppColors.cyan),
          const SizedBox(width: 10),
          const Text('Tiến độ bài', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
          const SizedBox(width: 12),
          Expanded(child: LinearProgressIndicator(value: progress, minHeight: 6, color: AppColors.cyan, backgroundColor: AppColors.borderSoft)),
          const SizedBox(width: 10),
          Text('${(progress * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w900)),
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
    if (nodes.length < 2) return;

    final points = nodes.map((node) => Offset(node.x * size.width, node.y * size.height)).toList(growable: false);
    final path = Path()..moveTo(points.first.dx, points.first.dy);

    for (var i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final current = points[i];
      final midY = (prev.dy + current.dy) / 2;
      path.cubicTo(prev.dx, midY, current.dx, midY, current.dx, current.dy);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xAAE7F6FF)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    final glowPaint = Paint()
      ..color = AppColors.purple.withOpacity(0.24)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _RoadPainter oldDelegate) => false;
}

class _JourneyBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF142D62), Color(0xFF111D3A), Color(0xFF07111E)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);

    final moonPaint = Paint()..color = const Color(0xFFFFDDAA).withOpacity(0.52);
    canvas.drawCircle(Offset(size.width * 0.76, 120), 54, moonPaint);

    final mountainBack = Paint()..color = const Color(0xFF142747);
    final mountainFront = Paint()..color = const Color(0xFF0D1B2E);

    _drawMountainLayer(canvas, size, mountainBack, 0.24, 0.10);
    _drawMountainLayer(canvas, size, mountainFront, 0.33, 0.18);

    final river = Path()
      ..moveTo(size.width * 0.10, size.height)
      ..cubicTo(size.width * 0.30, size.height * 0.78, size.width * 0.64, size.height * 0.72, size.width * 0.88, size.height * 0.46)
      ..lineTo(size.width, size.height * 0.52)
      ..cubicTo(size.width * 0.72, size.height * 0.75, size.width * 0.43, size.height * 0.84, size.width * 0.22, size.height)
      ..close();
    canvas.drawPath(river, Paint()..color = const Color(0xFF102D4E));

    final starPaint = Paint()..color = Colors.white.withOpacity(0.55);
    for (var i = 0; i < 44; i++) {
      final x = ((i * 73) % 997) / 997 * size.width;
      final y = ((i * 41) % 359) / 359 * (size.height * 0.36);
      canvas.drawCircle(Offset(x, y), i % 7 == 0 ? 1.6 : 0.8, starPaint);
    }
  }

  void _drawMountainLayer(Canvas canvas, Size size, Paint paint, double baseY, double variance) {
    final path = Path()..moveTo(0, size.height * baseY);
    const peaks = 8;
    for (var i = 0; i <= peaks; i++) {
      final x = size.width * i / peaks;
      final y = size.height * (baseY - ((i % 2 == 0 ? variance : variance * 0.35)));
      path.lineTo(x, y);
    }
    path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

String _nodeDescription(NodeState state) {
  return switch (state) {
    NodeState.cleared => 'Đã hoàn thành. Có thể học lại để cải thiện mastery và điểm cá nhân.',
    NodeState.current => 'Đây là node hiện tại của bạn. Tiếp tục chương để mở đoạn đường phía trước.',
    NodeState.available => 'Nội dung đã mở khóa và có thể bắt đầu bất cứ lúc nào.',
    NodeState.locked => 'Hoàn thành node trước để mở khóa nội dung này.',
    NodeState.boss => 'Bài kiểm tra cuối Bài 04. Tổng hợp toàn bộ kiến thức và 4 kỹ năng đã học.',
  };
}

enum NodeState { cleared, current, available, locked, boss }

class _MapNode {
  const _MapNode(this.id, this.x, this.y, this.label, this.state);

  final int id;
  final double x;
  final double y;
  final String label;
  final NodeState state;
}
