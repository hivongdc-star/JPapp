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
          constraints: const BoxConstraints(maxWidth: 1180),
          child: ListView(
            children: [
              const _PlayerHeader(),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final twoColumns = constraints.maxWidth >= 780;
                  final left = Column(
                    children: [
                      _ContinueLearningCard(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const LearningSessionScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const _TodayCard(),
                    ],
                  );
                  final right = const Column(
                    children: [
                      _SkillCard(),
                      SizedBox(height: 16),
                      _NearbyRankCard(),
                    ],
                  );

                  if (!twoColumns) {
                    return Column(
                      children: [left, const SizedBox(height: 16), right],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: left),
                      const SizedBox(width: 16),
                      Expanded(flex: 5, child: right),
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
    const identity = Row(
      children: [
        _PlayerAvatar(),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hikari', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              SizedBox(height: 4),
              Row(
                children: [
                  _TinyTag(label: 'N3', color: AppColors.gold),
                  SizedBox(width: 8),
                  Text('Rank #128', style: TextStyle(color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    const resources = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ResourcePill(icon: Icons.emoji_events_rounded, value: '12,250', color: AppColors.gold),
        SizedBox(width: 8),
        _ResourcePill(icon: Icons.replay_rounded, value: '12 ôn', color: AppColors.cyan),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 560) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              identity,
              SizedBox(height: 12),
              Align(alignment: Alignment.centerLeft, child: resources),
            ],
          );
        }

        return const Row(
          children: [
            Expanded(child: identity),
            SizedBox(width: 12),
            resources,
          ],
        );
      },
    );
  }
}

class _PlayerAvatar extends StatelessWidget {
  const _PlayerAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(colors: [AppColors.purple, AppColors.blue]),
        border: Border.all(color: AppColors.purpleBright, width: 2),
      ),
      child: const Icon(Icons.person_rounded, color: Colors.white, size: 34),
    );
  }
}

class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      padding: EdgeInsets.zero,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF153056), Color(0xFF0C172B), Color(0xFF181139)],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -34,
            top: -42,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.purple.withOpacity(0.12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('TIẾP TỤC HỌC', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w800)),
                const SizedBox(height: 22),
                const Text('N3 • Bài 04', style: TextStyle(color: AppColors.cyan, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text('Chương 03', style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                const Text('意見の幅を広げる', style: TextStyle(color: AppColors.textMuted, fontSize: 15)),
                const SizedBox(height: 18),
                const Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 0.58,
                        minHeight: 7,
                        color: AppColors.cyan,
                        backgroundColor: AppColors.borderSoft,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text('58%', style: TextStyle(fontWeight: FontWeight.w800)),
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
                const SizedBox(height: 10),
                const Center(
                  child: Text('Còn 12 bài tập trong chương', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard();

  @override
  Widget build(BuildContext context) {
    return const GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('HÔM NAY', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w800, fontSize: 12)),
          SizedBox(height: 14),
          _TodayRow(icon: Icons.menu_book_rounded, text: '1 chapter đang học', color: AppColors.blue),
          SizedBox(height: 12),
          _TodayRow(icon: Icons.auto_awesome_rounded, text: '12 mục cần ôn tập', color: AppColors.gold),
          SizedBox(height: 12),
          _TodayRow(icon: Icons.emoji_events_rounded, text: '0/1 thử thách hôm nay', color: AppColors.purpleBright),
        ],
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  const _SkillCard();

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('KỸ NĂNG HIỆN TẠI', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          ...skills.map((skill) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    SizedBox(width: 76, child: Text(skill.name, style: const TextStyle(fontSize: 12))),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: skill.score / 1000,
                        minHeight: 5,
                        color: _skillColor(skill.name),
                        backgroundColor: AppColors.borderSoft,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(width: 28, child: Text(skill.grade, style: TextStyle(color: _skillColor(skill.name), fontWeight: FontWeight.w900))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _NearbyRankCard extends StatelessWidget {
  const _NearbyRankCard();

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ĐỐI THỦ GẦN NHẤT', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ...nearbyRanks.map((entry) => Container(
                margin: const EdgeInsets.only(bottom: 7),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                decoration: BoxDecoration(
                  color: entry.isCurrentUser ? AppColors.purple.withOpacity(0.18) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: entry.isCurrentUser ? Border.all(color: AppColors.purple.withOpacity(0.5)) : null,
                ),
                child: Row(
                  children: [
                    SizedBox(width: 44, child: Text('#${entry.rank}', style: TextStyle(color: entry.isCurrentUser ? AppColors.purpleBright : AppColors.textMuted))),
                    Expanded(child: Text(entry.name, style: TextStyle(fontWeight: entry.isCurrentUser ? FontWeight.w800 : FontWeight.w600))),
                    Text('${entry.score}', style: const TextStyle(fontWeight: FontWeight.w800)),
                  ],
                ),
              )),
          const SizedBox(height: 6),
          const Center(
            child: Text('Cần +340 để vượt #127', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w800, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _ResourcePill extends StatelessWidget {
  const _ResourcePill({required this.icon, required this.value, required this.color});

  final IconData icon;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Row(children: [Icon(icon, color: color, size: 17), const SizedBox(width: 6), Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))]),
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
      decoration: BoxDecoration(color: color.withOpacity(0.16), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.45))),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900)),
    );
  }
}

class _TodayRow extends StatelessWidget {
  const _TodayRow({required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(children: [Container(width: 34, height: 34, decoration: BoxDecoration(color: color.withOpacity(0.14), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 18)), const SizedBox(width: 12), Text(text)]);
  }
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
