import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/game_panel.dart';
import '../../core/widgets/scene_scaffold.dart';
import '../../data/mock_data.dart';

class AbilityScene extends StatefulWidget {
  const AbilityScene({super.key});

  @override
  State<AbilityScene> createState() => _AbilitySceneState();
}

class _AbilitySceneState extends State<AbilityScene> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SceneScaffold(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: ListView(
            children: [
              _SegmentBar(
                items: const ['Tổng quan', 'Chi tiết'],
                selectedIndex: _tabIndex,
                onSelected: (index) => setState(() => _tabIndex = index),
              ),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 980;
                  if (!wide) {
                    return const Column(
                      children: [
                        _AbilityHeroCard(),
                        SizedBox(height: 16),
                        _SkillGrid(),
                        SizedBox(height: 16),
                        _InsightGrid(),
                      ],
                    );
                  }

                  return const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 11, child: _AbilityHeroCard()),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 9,
                        child: Column(
                          children: [
                            _SkillGrid(),
                            SizedBox(height: 16),
                            _InsightGrid(),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SegmentBar extends StatelessWidget {
  const _SegmentBar({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: List.generate(items.length, (index) {
          final selected = selectedIndex == index;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index == items.length - 1 ? 0 : 8),
              child: InkWell(
                onTap: () => onSelected(index),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: selected
                        ? const LinearGradient(colors: [Color(0xFF8A4BFF), Color(0xFF5D47FF)])
                        : null,
                    color: selected ? null : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    items[index],
                    style: TextStyle(
                      color: selected ? Colors.white : AppColors.textMuted,
                      fontWeight: FontWeight.w700,
                    ),
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

class _AbilityHeroCard extends StatelessWidget {
  const _AbilityHeroCard();

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF121B39), Color(0xFF0A1222), Color(0xFF080E1A)],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -30,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.purple.withOpacity(0.08),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 620;
              if (narrow) {
                return const Column(
                  children: [
                    _HeroSummary(),
                    SizedBox(height: 18),
                    _PortraitPanel(),
                  ],
                );
              }

              return const Row(
                children: [
                  Expanded(child: _HeroSummary()),
                  SizedBox(width: 18),
                  _PortraitPanel(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeroSummary extends StatelessWidget {
  const _HeroSummary();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TỔNG NĂNG LỰC', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(colors: [Color(0xFFC693FF), Colors.white]).createShader(bounds),
          child: const Text(
            'N3+',
            style: TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ),
        const Text('Đang tiến gần N2', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 18),
        const Text('Kinh nghiệm', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(999)),
          child: LinearProgressIndicator(
            value: 0.68,
            minHeight: 8,
            color: AppColors.purpleBright,
            backgroundColor: AppColors.borderSoft,
          ),
        ),
        const SizedBox(height: 10),
        const Text('12,840 / 18,800', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
        const SizedBox(height: 22),
        const _HeroMetaRow(),
      ],
    );
  }
}

class _HeroMetaRow extends StatelessWidget {
  const _HeroMetaRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: const [
        _MetaPill(icon: Icons.bolt_rounded, label: 'Lv. 27'),
        _MetaPill(icon: Icons.emoji_events_rounded, label: 'Rank #128'),
        _MetaPill(icon: Icons.timeline_rounded, label: '92% độ ổn định'),
      ],
    );
  }
}

class _PortraitPanel extends StatelessWidget {
  const _PortraitPanel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(colors: [Color(0xFF25124C), Color(0xFF090F1A)]),
              border: Border.all(color: AppColors.purpleBright, width: 4),
              boxShadow: const [BoxShadow(color: Color(0x668754FF), blurRadius: 36)],
            ),
            child: const CustomPaint(painter: _PortraitPainter()),
          ),
          Positioned(
            right: -4,
            bottom: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.backgroundRaised,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.cyan.withOpacity(0.4)),
              ),
              child: const Text('Lv. 27', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillGrid extends StatelessWidget {
  const _SkillGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 560 ? 4 : 2;
        final width = (constraints.maxWidth - ((columns - 1) * 12)) / columns;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: skills.map((skill) => SizedBox(width: width, child: _SkillCard(skill: skill))).toList(growable: false),
        );
      },
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.skill});

  final SkillSnapshot skill;

  @override
  Widget build(BuildContext context) {
    final color = _skillColor(skill.name);
    final icon = IconData(skill.iconCodePoint, fontFamily: 'MaterialIcons');

    return GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(skill.name, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(skill.grade, style: TextStyle(color: color, fontSize: 34, fontWeight: FontWeight.w900)),
          Text('${skill.score} / 1000', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(999)),
            child: LinearProgressIndicator(
              value: skill.score / 1000,
              minHeight: 6,
              color: color,
              backgroundColor: AppColors.borderSoft,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightGrid extends StatelessWidget {
  const _InsightGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 560;
        const strong = _InsightPanel(
          title: 'ĐIỂM MẠNH',
          color: AppColors.green,
          items: ['Đọc hiểu văn bản dài', 'Ngữ pháp N3 cơ bản', 'Từ vựng học thuật'],
        );
        const weak = _InsightPanel(
          title: 'ĐIỂM CẦN CẢI THIỆN',
          color: AppColors.red,
          items: ['Nghe tốc độ tự nhiên', 'Nói phản xạ tự do', 'Viết mạch lạc hơn'],
        );
        if (!wide) {
          return const Column(children: [strong, SizedBox(height: 12), weak]);
        }
        return const Row(
          children: [
            Expanded(child: strong),
            SizedBox(width: 12),
            Expanded(child: weak),
          ],
        );
      },
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
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 7, color: color),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.backgroundRaised,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.cyan),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }
}

class _PortraitPainter extends CustomPainter {
  const _PortraitPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, size.width * 0.40, Paint()..color = const Color(0x2200B8FF));

    final coatPaint = Paint()..color = const Color(0xFF0B0F17);
    final accentPaint = Paint()..color = const Color(0xFF171F2E);
    final skinPaint = Paint()..color = const Color(0xFFF3D3C0);
    final hairPaint = Paint()..color = const Color(0xFF151618);
    final eyePaint = Paint()..color = const Color(0xFF3ACBFF);

    final shoulders = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 70), width: 118, height: 88),
      const Radius.circular(28),
    );
    canvas.drawRRect(shoulders, coatPaint);

    final collar = Path()
      ..moveTo(center.dx - 16, center.dy + 44)
      ..lineTo(center.dx, center.dy + 72)
      ..lineTo(center.dx + 16, center.dy + 44)
      ..lineTo(center.dx + 6, center.dy + 42)
      ..lineTo(center.dx, center.dy + 52)
      ..lineTo(center.dx - 6, center.dy + 42)
      ..close();
    canvas.drawPath(collar, accentPaint);

    canvas.drawCircle(Offset(center.dx, center.dy - 6), 42, skinPaint);

    final hair = Path()
      ..moveTo(center.dx - 48, center.dy - 20)
      ..quadraticBezierTo(center.dx - 30, center.dy - 72, center.dx + 2, center.dy - 62)
      ..quadraticBezierTo(center.dx + 36, center.dy - 76, center.dx + 50, center.dy - 24)
      ..quadraticBezierTo(center.dx + 34, center.dy - 18, center.dx + 16, center.dy - 10)
      ..quadraticBezierTo(center.dx + 10, center.dy - 2, center.dx + 6, center.dy + 18)
      ..lineTo(center.dx - 12, center.dy + 20)
      ..quadraticBezierTo(center.dx - 18, center.dy - 2, center.dx - 36, center.dy - 10)
      ..quadraticBezierTo(center.dx - 44, center.dy - 14, center.dx - 48, center.dy - 20)
      ..close();
    canvas.drawPath(hair, hairPaint);

    final leftEye = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx - 14, center.dy - 2), width: 12, height: 8),
      const Radius.circular(6),
    );
    final rightEye = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx + 14, center.dy - 2), width: 12, height: 8),
      const Radius.circular(6),
    );
    canvas.drawRRect(leftEye, eyePaint);
    canvas.drawRRect(rightEye, eyePaint);
    canvas.drawCircle(Offset(center.dx - 14, center.dy - 2), 2, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(center.dx + 14, center.dy - 2), 2, Paint()..color = Colors.white);

    canvas.drawLine(
      Offset(center.dx - 6, center.dy + 16),
      Offset(center.dx + 6, center.dy + 16),
      Paint()
        ..color = const Color(0xFF7E5757)
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );

    for (var index = 0; index < 18; index++) {
      final angle = index * math.pi * 2 / 18;
      final point = Offset(center.dx + math.cos(angle) * 102, center.dy + math.sin(angle) * 102);
      canvas.drawCircle(point, 1.4, Paint()..color = AppColors.purpleBright.withOpacity(0.8));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Color _skillColor(String name) {
  switch (name) {
    case 'Listening':
      return AppColors.green;
    case 'Speaking':
      return AppColors.gold;
    case 'Reading':
      return AppColors.green;
    default:
      return AppColors.blue;
  }
}
