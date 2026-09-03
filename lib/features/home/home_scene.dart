import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/game_panel.dart';
import '../../core/widgets/scene_scaffold.dart';
import '../../data/mock_data.dart';
import '../learning/learning_session_screen.dart';

class HomeScene extends StatelessWidget {
  const HomeScene({super.key});

  @override
  Widget build(BuildContext context) {
    return SceneScaffold(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: ListView(
            children: [
              const _PlayerHeader(),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  final useTwoColumns = constraints.maxWidth >= 940;
                  const rightColumn = Column(
                    children: [
                      _CurrentSkillPanel(),
                      SizedBox(height: 16),
                      _NearbyRankPanel(),
                    ],
                  );
                  final leftColumn = Column(
                    children: [
                      _ContinueLearningPanel(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const LearningSessionScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const _TodayPanel(),
                    ],
                  );

                  if (!useTwoColumns) {
                    return Column(
                      children: [leftColumn, const SizedBox(height: 16), rightColumn],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 11, child: leftColumn),
                      const SizedBox(width: 16),
                      const Expanded(flex: 9, child: rightColumn),
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

class _PlayerHeader extends StatelessWidget {
  const _PlayerHeader();

  @override
  Widget build(BuildContext context) {
    final identity = Row(
      children: [
        const _AvatarBadge(size: 56),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Row(
                children: [
                  Text('Hikari', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  SizedBox(width: 6),
                  Icon(Icons.edit_rounded, size: 15, color: AppColors.textMuted),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  _TinyTag(label: 'N3', color: AppColors.gold),
                  SizedBox(width: 8),
                  Text('🏆 Rank 128', style: TextStyle(color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    final resources = Wrap(
      spacing: 10,
      runSpacing: 10,
      children: const [
        _ResourcePill(icon: Icons.flash_on_rounded, value: '20/20', suffixIcon: Icons.add_circle_rounded, color: AppColors.gold),
        _ResourcePill(icon: Icons.diamond_rounded, value: '1,250', color: AppColors.blue),
        _ResourcePill(icon: Icons.monetization_on_rounded, value: '12,840', color: AppColors.gold),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 760) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [identity, const SizedBox(height: 14), resources],
          );
        }
        return Row(
          children: [
            Expanded(child: identity),
            const SizedBox(width: 16),
            resources,
          ],
        );
      },
    );
  }
}

class _ContinueLearningPanel extends StatelessWidget {
  const _ContinueLearningPanel({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      padding: EdgeInsets.zero,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF102247), Color(0xFF0A1327), Color(0xFF171033)],
      ),
      child: SizedBox(
        height: 330,
        child: Stack(
          children: [
            const Positioned.fill(child: CustomPaint(painter: _HeroBackdropPainter())),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.background.withOpacity(0.12),
                      AppColors.background.withOpacity(0.62),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TIẾP TỤC HỌC', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 18),
                  const Text('N3 • Bài 04', style: TextStyle(color: AppColors.cyan, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const Text('Chương 03', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  const Text('意見の幅を広げる', style: TextStyle(color: AppColors.textMuted, fontSize: 15)),
                  const Spacer(),
                  Row(
                    children: const [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(999)),
                          child: LinearProgressIndicator(
                            value: 0.58,
                            minHeight: 9,
                            color: AppColors.blue,
                            backgroundColor: AppColors.borderSoft,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('58%', style: TextStyle(fontWeight: FontWeight.w900)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: onPressed,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('TIẾP TỤC HỌC'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text('Còn 12 bài tập trong chương', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentSkillPanel extends StatelessWidget {
  const _CurrentSkillPanel();

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('KỸ NĂNG HIỆN TẠI', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 430;
              const chart = SizedBox(
                width: 162,
                height: 162,
                child: CustomPaint(painter: _MiniRadarPainter([0.78, 0.64, 0.85, 0.69])),
              );
              final stats = Expanded(
                child: Column(
                  children: skills
                      .map((skill) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _SkillProgressRow(skill: skill),
                          ))
                      .toList(growable: false),
                ),
              );

              if (compact) {
                return Column(children: [chart, const SizedBox(height: 12), stats]);
              }
              return Row(children: [chart, const SizedBox(width: 18), stats]);
            },
          ),
        ],
      ),
    );
  }
}

class _TodayPanel extends StatelessWidget {
  const _TodayPanel();

  @override
  Widget build(BuildContext context) {
    return const GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('HÔM NAY', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w800)),
          SizedBox(height: 14),
          _TodayRow(item: _TodayItem(Icons.menu_book_rounded, '1 chapter đang học', AppColors.blue)),
          SizedBox(height: 12),
          _TodayRow(item: _TodayItem(Icons.emoji_events_rounded, '12 mục cần ôn tập', AppColors.gold)),
          SizedBox(height: 12),
          _TodayRow(item: _TodayItem(Icons.workspace_premium_rounded, '0/1 thử thách hôm nay', AppColors.purpleBright)),
        ],
      ),
    );
  }
}

class _NearbyRankPanel extends StatelessWidget {
  const _NearbyRankPanel();

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ĐỐI THỦ GẦN NHẤT', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ...nearbyRanks.map(
            (entry) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: entry.isCurrentUser ? AppColors.purple.withOpacity(0.18) : AppColors.backgroundRaised.withOpacity(0.55),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: entry.isCurrentUser ? AppColors.purple.withOpacity(0.55) : AppColors.borderSoft,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 38,
                    child: Text(
                      '#${entry.rank}',
                      style: TextStyle(
                        color: entry.isCurrentUser ? AppColors.purpleBright : AppColors.textMuted,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const _AvatarBadge(size: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.name,
                      style: TextStyle(fontWeight: entry.isCurrentUser ? FontWeight.w800 : FontWeight.w600),
                    ),
                  ),
                  Text(
                    '${entry.score}',
                    style: TextStyle(color: entry.isCurrentUser ? AppColors.gold : AppColors.text, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text('Cần +340 để vượt #127', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w800, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _SkillProgressRow extends StatelessWidget {
  const _SkillProgressRow({required this.skill});

  final SkillSnapshot skill;

  @override
  Widget build(BuildContext context) {
    final color = _skillColor(skill.name);
    return Row(
      children: [
        SizedBox(
          width: 78,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(skill.name, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Text('${skill.score}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(999)),
                child: LinearProgressIndicator(
                  value: skill.score / 1000,
                  minHeight: 5,
                  color: color,
                  backgroundColor: AppColors.borderSoft,
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(skill.grade, style: TextStyle(color: color, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResourcePill extends StatelessWidget {
  const _ResourcePill({required this.icon, required this.value, required this.color, this.suffixIcon});

  final IconData icon;
  final String value;
  final Color color;
  final IconData? suffixIcon;

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
          Icon(icon, color: color, size: 17),
          const SizedBox(width: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
          if (suffixIcon != null) ...[
            const SizedBox(width: 6),
            Icon(suffixIcon, color: AppColors.green, size: 16),
          ],
        ],
      ),
    );
  }
}

class _TinyTag extends StatelessWidget {
  const _TinyTag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.40)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900)),
    );
  }
}

class _AvatarBadge extends StatelessWidget {
  const _AvatarBadge({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF313E6F), Color(0xFF0B1223)]),
        border: Border.all(color: Colors.white.withOpacity(0.16), width: 1.4),
        boxShadow: const [BoxShadow(color: Color(0x55000000), blurRadius: 14, offset: Offset(0, 8))],
      ),
      child: Icon(Icons.person_rounded, color: Colors.white.withOpacity(0.92), size: size * 0.58),
    );
  }
}

class _TodayItem {
  const _TodayItem(this.icon, this.label, this.color);

  final IconData icon;
  final String label;
  final Color color;
}

class _TodayRow extends StatelessWidget {
  const _TodayRow({required this.item});

  final _TodayItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(color: item.color.withOpacity(0.14), borderRadius: BorderRadius.circular(12)),
          child: Icon(item.icon, color: item.color, size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(item.label)),
      ],
    );
  }
}

class _HeroBackdropPainter extends CustomPainter {
  const _HeroBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1A356A), Color(0xFF172043), Color(0xFF0B1022)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, skyPaint);

    final moonPaint = Paint()..color = const Color(0xFFE4B2FF).withOpacity(0.30);
    canvas.drawCircle(Offset(size.width * 0.84, size.height * 0.18), size.height * 0.16, moonPaint);

    final mountain = Path()
      ..moveTo(0, size.height * 0.62)
      ..lineTo(size.width * 0.18, size.height * 0.38)
      ..lineTo(size.width * 0.30, size.height * 0.52)
      ..lineTo(size.width * 0.45, size.height * 0.30)
      ..lineTo(size.width * 0.60, size.height * 0.54)
      ..lineTo(size.width * 0.80, size.height * 0.36)
      ..lineTo(size.width, size.height * 0.58)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(mountain, Paint()..color = const Color(0xFF0E1F3C));

    final ground = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.72)
      ..quadraticBezierTo(size.width * 0.14, size.height * 0.66, size.width * 0.26, size.height * 0.74)
      ..quadraticBezierTo(size.width * 0.47, size.height * 0.82, size.width * 0.60, size.height * 0.70)
      ..quadraticBezierTo(size.width * 0.80, size.height * 0.56, size.width, size.height * 0.76)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(ground, Paint()..color = const Color(0xFF091322));

    final river = Path()
      ..moveTo(size.width * 0.72, size.height)
      ..quadraticBezierTo(size.width * 0.64, size.height * 0.84, size.width * 0.59, size.height * 0.66)
      ..quadraticBezierTo(size.width * 0.53, size.height * 0.50, size.width * 0.46, size.height * 0.38)
      ..quadraticBezierTo(size.width * 0.42, size.height * 0.32, size.width * 0.42, 0)
      ..lineTo(size.width * 0.52, 0)
      ..quadraticBezierTo(size.width * 0.56, size.height * 0.32, size.width * 0.61, size.height * 0.44)
      ..quadraticBezierTo(size.width * 0.68, size.height * 0.60, size.width * 0.82, size.height)
      ..close();
    canvas.drawPath(river, Paint()..color = const Color(0xFF18386C));

    final blossomPaint = Paint()..color = const Color(0xFFF07BC7).withOpacity(0.32);
    for (var i = 0; i < 26; i++) {
      final dx = size.width * 0.07 + (i * 29 % 120);
      final dy = size.height * 0.16 + (i * 17 % 92);
      canvas.drawCircle(Offset(dx, dy), 4 + (i % 3).toDouble(), blossomPaint);
      canvas.drawCircle(Offset(size.width * 0.88 - dx * 0.18, dy + 30), 3.5, blossomPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MiniRadarPainter extends CustomPainter {
  const _MiniRadarPainter(this.values);

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.34;
    const axes = 4;

    final grid = Paint()
      ..style = PaintingStyle.stroke
      ..color = AppColors.border;
    final axisPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.borderSoft;

    for (var ring = 1; ring <= 4; ring++) {
      final path = Path();
      final currentRadius = radius * ring / 4;
      for (var i = 0; i < axes; i++) {
        final angle = -math.pi / 2 + i * math.pi * 2 / axes;
        final point = Offset(center.dx + math.cos(angle) * currentRadius, center.dy + math.sin(angle) * currentRadius);
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, grid);
    }

    for (var i = 0; i < axes; i++) {
      final angle = -math.pi / 2 + i * math.pi * 2 / axes;
      final point = Offset(center.dx + math.cos(angle) * radius, center.dy + math.sin(angle) * radius);
      canvas.drawLine(center, point, axisPaint);
    }

    final shape = Path();
    for (var i = 0; i < axes; i++) {
      final angle = -math.pi / 2 + i * math.pi * 2 / axes;
      final point = Offset(center.dx + math.cos(angle) * radius * values[i], center.dy + math.sin(angle) * radius * values[i]);
      if (i == 0) {
        shape.moveTo(point.dx, point.dy);
      } else {
        shape.lineTo(point.dx, point.dy);
      }
    }
    shape.close();

    canvas.drawPath(shape, Paint()..color = AppColors.blue.withOpacity(0.18));
    canvas.drawPath(
      shape,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = AppColors.cyan,
    );
  }

  @override
  bool shouldRepaint(covariant _MiniRadarPainter oldDelegate) => false;
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
