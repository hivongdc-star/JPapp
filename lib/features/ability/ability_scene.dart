import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/game_panel.dart';
import '../../core/widgets/scene_scaffold.dart';
import '../../data/mock_data.dart';

class AbilityScene extends StatelessWidget {
  const AbilityScene({super.key});

  @override
  Widget build(BuildContext context) {
    return SceneScaffold(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: ListView(
            children: [
              const Text('Kỹ năng cá nhân', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              const Text('Năng lực thực tế được tổng hợp từ bài học, test và challenge đã xác minh.', style: TextStyle(color: AppColors.textMuted)),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 860;
                  final summary = const _AbilitySummary();
                  final radar = const _RadarPanel();
                  if (!wide) return Column(children: [summary, const SizedBox(height: 16), radar]);
                  return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Expanded(flex: 6, child: summary), const SizedBox(width: 16), Expanded(flex: 4, child: radar)]);
                },
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 760 ? 4 : 2;
                  final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: skills.map((skill) => SizedBox(width: width, child: _SkillStatCard(skill: skill))).toList(growable: false),
                  );
                },
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 720;
                  final strong = const _InsightPanel(
                    title: 'ĐIỂM MẠNH',
                    color: AppColors.green,
                    items: ['Đọc hiểu văn bản dài', 'Ngữ pháp N3 cơ bản', 'Từ vựng học thuật'],
                  );
                  final weak = const _InsightPanel(
                    title: 'CẦN CẢI THIỆN',
                    color: AppColors.red,
                    items: ['Nghe tốc độ tự nhiên', 'Nói phản xạ tự do', 'Viết mạch lạc hơn'],
                  );
                  if (!wide) return Column(children: [strong, const SizedBox(height: 12), weak]);
                  return Row(children: [Expanded(child: strong), const SizedBox(width: 12), Expanded(child: weak)]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AbilitySummary extends StatelessWidget {
  const _AbilitySummary();

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      gradient: const LinearGradient(colors: [Color(0xFF15113B), Color(0xFF0C172B)]),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TỔNG NĂNG LỰC', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w800, fontSize: 12)),
                SizedBox(height: 12),
                Text('N3+', style: TextStyle(fontSize: 46, color: AppColors.purpleBright, fontWeight: FontWeight.w900)),
                Text('Đang tiến gần N2', style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(height: 20),
                Text('Kinh nghiệm học thuật', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                SizedBox(height: 7),
                LinearProgressIndicator(value: 0.68, minHeight: 7, color: AppColors.purpleBright, backgroundColor: AppColors.borderSoft),
                SizedBox(height: 8),
                Text('12,840 / 18,800', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 126,
            height: 126,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(colors: [Color(0xFF331A66), Color(0xFF0D1024)]),
              border: Border.all(color: AppColors.purpleBright, width: 3),
              boxShadow: const [BoxShadow(color: Color(0x668754FF), blurRadius: 28)],
            ),
            child: const Icon(Icons.person_rounded, size: 82, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _RadarPanel extends StatelessWidget {
  const _RadarPanel();

  @override
  Widget build(BuildContext context) {
    return const GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SKILL SHAPE', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w800)),
          SizedBox(height: 10),
          AspectRatio(aspectRatio: 1.45, child: CustomPaint(painter: _RadarPainter(values: [0.782, 0.641, 0.846, 0.693]))),
        ],
      ),
    );
  }
}

class _SkillStatCard extends StatelessWidget {
  const _SkillStatCard({required this.skill});

  final SkillSnapshot skill;

  @override
  Widget build(BuildContext context) {
    final color = _skillColor(skill.name);
    final icon = IconData(skill.iconCodePoint, fontFamily: 'MaterialIcons');
    return GamePanel(
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(skill.name, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(skill.grade, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.w900)),
          Text('${skill.score}/1000', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: skill.score / 1000, minHeight: 5, color: color, backgroundColor: AppColors.borderSoft),
        ],
      ),
    );
  }
}

class _InsightPanel extends StatelessWidget {
  const _InsightPanel({required this.title, required this.color, required this.items});

  final String title;
  final Color color;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [Icon(Icons.circle, size: 6, color: color), const SizedBox(width: 9), Expanded(child: Text(item))]),
              )),
        ],
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  const _RadarPainter({required this.values});

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.38;
    const axes = 4;

    final gridPaint = Paint()..color = AppColors.border;
    for (var ring = 1; ring <= 4; ring++) {
      final path = Path();
      final r = radius * ring / 4;
      for (var i = 0; i < axes; i++) {
        final angle = -math.pi / 2 + i * math.pi * 2 / axes;
        final p = Offset(center.dx + math.cos(angle) * r, center.dy + math.sin(angle) * r);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint..style = PaintingStyle.stroke);
    }

    final shape = Path();
    for (var i = 0; i < axes; i++) {
      final angle = -math.pi / 2 + i * math.pi * 2 / axes;
      final r = radius * values[i];
      final p = Offset(center.dx + math.cos(angle) * r, center.dy + math.sin(angle) * r);
      if (i == 0) {
        shape.moveTo(p.dx, p.dy);
      } else {
        shape.lineTo(p.dx, p.dy);
      }
    }
    shape.close();
    canvas.drawPath(shape, Paint()..color = AppColors.blue.withOpacity(0.20));
    canvas.drawPath(shape, Paint()..color = AppColors.cyan..style = PaintingStyle.stroke..strokeWidth = 2.5);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => false;
}

Color _skillColor(String name) {
  switch (name) {
    case 'Listening':
      return AppColors.green;
    case 'Speaking':
      return AppColors.orange;
    case 'Reading':
      return AppColors.green;
    default:
      return AppColors.blue;
  }
}
