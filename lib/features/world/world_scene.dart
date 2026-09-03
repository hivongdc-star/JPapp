import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/game_panel.dart';
import '../../core/widgets/scene_scaffold.dart';
import '../../data/mock_data.dart';

class WorldScene extends StatefulWidget {
  const WorldScene({super.key});

  @override
  State<WorldScene> createState() => _WorldSceneState();
}

class _WorldSceneState extends State<WorldScene> {
  int _section = 0;

  static const _sections = [
    (Icons.dashboard_rounded, 'Tổng quan'),
    (Icons.chat_bubble_rounded, 'Chat'),
    (Icons.leaderboard_rounded, 'Rank'),
    (Icons.workspace_premium_rounded, 'Thử thách'),
    (Icons.people_alt_rounded, 'Bạn bè'),
    (Icons.groups_rounded, 'Nhóm học'),
    (Icons.event_rounded, 'Sự kiện'),
  ];

  @override
  Widget build(BuildContext context) {
    return SceneScaffold(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final useSidebar = constraints.maxWidth >= 980;
              if (!useSidebar) {
                return Column(
                  children: [
                    SizedBox(
                      height: 44,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _sections.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final selected = _section == index;
                          return ChoiceChip(
                            selected: selected,
                            label: Text(_sections[index].$2),
                            onSelected: (_) => setState(() => _section = index),
                            selectedColor: AppColors.purple.withOpacity(0.22),
                            side: BorderSide(color: selected ? AppColors.purple : AppColors.borderSoft),
                            labelStyle: TextStyle(
                              color: selected ? AppColors.purpleBright : AppColors.textMuted,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    Expanded(child: _WorldContent(index: _section)),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 220,
                    child: _WorldSidebar(
                      selectedIndex: _section,
                      onSelect: (index) => setState(() => _section = index),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _WorldContent(index: _section)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WorldSidebar extends StatelessWidget {
  const _WorldSidebar({required this.selectedIndex, required this.onSelect});

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('WORLD', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w900, fontSize: 12)),
          const SizedBox(height: 14),
          ...List.generate(_WorldSceneState._sections.length, (index) {
            final item = _WorldSceneState._sections[index];
            final selected = selectedIndex == index;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => onSelect(index),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.purple.withOpacity(0.20) : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: selected ? AppColors.purple : Colors.transparent),
                  ),
                  child: Row(
                    children: [
                      Icon(item.$1, color: selected ? AppColors.purpleBright : AppColors.textMuted),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.$2,
                          style: TextStyle(
                            color: selected ? AppColors.text : AppColors.textMuted,
                            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (item.$2 == 'Rank')
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _WorldContent extends StatelessWidget {
  const _WorldContent({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return switch (index) {
      0 => const _OverviewSection(),
      1 => const ListView(children: [_FeaturedChatPanel()]),
      2 => const ListView(children: [_WeeklyLeaguePanel(), SizedBox(height: 16), _LeaderboardPanel()]),
      3 => const ListView(children: [_ActiveChallengePanel()]),
      4 => const ListView(children: [_FriendsPanel()]),
      5 => const ListView(children: [_StudyGroupsPanel()]),
      _ => const ListView(children: [_EventsPanel()]),
    };
  }
}

class _OverviewSection extends StatelessWidget {
  const _OverviewSection();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 860;
            const league = _WeeklyLeaguePanel();
            const challenge = _ActiveChallengePanel();
            if (!wide) {
              return const Column(children: [league, SizedBox(height: 16), challenge]);
            }
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: league),
                SizedBox(width: 16),
                Expanded(flex: 5, child: challenge),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 860;
            const chat = _FeaturedChatPanel();
            const rank = _LeaderboardPanel();
            if (!wide) {
              return const Column(children: [chat, SizedBox(height: 16), rank]);
            }
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: chat),
                SizedBox(width: 16),
                Expanded(child: rank),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _WeeklyLeaguePanel extends StatelessWidget {
  const _WeeklyLeaguePanel();

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF10234A), Color(0xFF0C1730), Color(0xFF111327)],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -30,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.blue.withOpacity(0.06)),
            ),
          ),
          Row(
            children: [
              Container(
                width: 126,
                height: 126,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(colors: [Color(0xFF75E5FF), Color(0xFF2E5EC6), Color(0xFF142548)]),
                  border: Border.all(color: Colors.white.withOpacity(0.18), width: 2),
                  boxShadow: const [BoxShadow(color: Color(0x553AD7FF), blurRadius: 28)],
                ),
                child: const Icon(Icons.diamond_rounded, color: Colors.white, size: 68),
              ),
              const SizedBox(width: 18),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text('WEEKLY LEAGUE', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w800, fontSize: 12))),
                        _TimeBadge(),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text('Diamond League', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                    SizedBox(height: 12),
                    Text('Rank hiện tại: #128', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    SizedBox(height: 6),
                    Text('Còn 340 điểm để lên #127', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActiveChallengePanel extends StatelessWidget {
  const _ActiveChallengePanel();

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('THỬ THÁCH ĐANG DIỄN RA', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w800, fontSize: 12)),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.gold.withOpacity(0.18),
                  border: Border.all(color: AppColors.gold.withOpacity(0.40)),
                ),
                child: const Icon(Icons.add_rounded, color: AppColors.gold, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.backgroundRaised,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSoft),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.headphones_rounded, color: AppColors.purpleBright),
                    SizedBox(width: 10),
                    Expanded(child: Text('N3 Listening Sprint', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18))),
                  ],
                ),
                SizedBox(height: 8),
                Text('10 bài nghe • 1 lần thi chính thức', style: TextStyle(color: AppColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text('Thời gian còn lại', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const SizedBox(height: 6),
          const Text('2d 08h 34m', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: () {}, child: const Text('THAM GIA NGAY'))),
        ],
      ),
    );
  }
}

class _FeaturedChatPanel extends StatelessWidget {
  const _FeaturedChatPanel();

  @override
  Widget build(BuildContext context) {
    const rooms = [
      ('N3 Study Room', '128 online', AppColors.blue, Icons.shield_rounded),
      ('Speaking Practice', '92 online', AppColors.cyan, Icons.record_voice_over_rounded),
      ('Vietnamese Learners', '256 online', AppColors.red, Icons.flag_rounded),
    ];

    return GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PHÒNG CHAT NỔI BẬT', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w800, fontSize: 12)),
          const SizedBox(height: 14),
          ...rooms.map(
            (room) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.backgroundRaised.withOpacity(0.68),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderSoft),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: room.$3.withOpacity(0.16), borderRadius: BorderRadius.circular(14)),
                    child: Icon(room.$4, color: room.$3),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(room.$1, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(room.$2, style: const TextStyle(color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.panelAlt, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardPanel extends StatelessWidget {
  const _LeaderboardPanel();

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: Text('BẢNG XẾP HẠNG TUẦN', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w800, fontSize: 12))),
              TextButton(onPressed: () {}, child: const Text('Xem tất cả')),
            ],
          ),
          const SizedBox(height: 8),
          ...weeklyTop.map(
            (entry) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                color: entry.isCurrentUser ? AppColors.purple.withOpacity(0.18) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: entry.isCurrentUser ? Border.all(color: AppColors.purple.withOpacity(0.45)) : null,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 42,
                    child: Text(
                      '#${entry.rank}',
                      style: TextStyle(color: entry.rank <= 3 ? AppColors.gold : AppColors.textMuted, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const _MiniAvatar(),
                  const SizedBox(width: 10),
                  Expanded(child: Text(entry.name, style: const TextStyle(fontWeight: FontWeight.w700))),
                  Text('${entry.score}', style: const TextStyle(fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FriendsPanel extends StatelessWidget {
  const _FriendsPanel();

  @override
  Widget build(BuildContext context) {
    const friends = ['Kaito', 'Minato', 'Haru', 'Sora'];
    return GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('BẠN BÈ ĐANG ONLINE', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w800, fontSize: 12)),
          const SizedBox(height: 14),
          ...friends.map(
            (name) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const _MiniAvatar(),
              title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('Đang học bài N3'),
              trailing: OutlinedButton(onPressed: () {}, child: const Text('Mời')),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudyGroupsPanel extends StatelessWidget {
  const _StudyGroupsPanel();

  @override
  Widget build(BuildContext context) {
    return const GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('NHÓM HỌC', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w800, fontSize: 12)),
          SizedBox(height: 12),
          Text('N3 Intensive Group', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          SizedBox(height: 8),
          Text('Lịch gặp: T2 / T4 / T6 • 20:00 JST'),
          SizedBox(height: 8),
          Text('Mục tiêu: tăng tốc Reading và Speaking trước kỳ JLPT gần nhất.', style: TextStyle(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _EventsPanel extends StatelessWidget {
  const _EventsPanel();

  @override
  Widget build(BuildContext context) {
    return const GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('SỰ KIỆN', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w800, fontSize: 12)),
          SizedBox(height: 12),
          Text('Season 01 - Road to N2', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          SizedBox(height: 8),
          Text('Hoàn thành 6 lesson test trong tháng để nhận title độc quyền.', style: TextStyle(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _MiniAvatar extends StatelessWidget {
  const _MiniAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(colors: [Color(0xFF32406B), Color(0xFF0E1524)]),
        border: Border.all(color: Colors.white.withOpacity(0.16), width: 1),
      ),
      child: const Icon(Icons.person_rounded, size: 18, color: Colors.white),
    );
  }
}

class _TimeBadge extends StatelessWidget {
  const _TimeBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundRaised,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule_rounded, size: 14, color: AppColors.cyan),
          SizedBox(width: 6),
          Text('2d 08h', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
