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

  static const _sections = ['Tổng quan', 'Chat', 'Rank', 'Thử thách', 'Bạn bè'];

  @override
  Widget build(BuildContext context) {
    return SceneScaffold(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Column(
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
                      label: Text(_sections[index]),
                      onSelected: (_) => setState(() => _section = index),
                      selectedColor: AppColors.purple.withOpacity(0.22),
                      side: BorderSide(color: selected ? AppColors.purple : AppColors.borderSoft),
                      labelStyle: TextStyle(color: selected ? AppColors.purpleBright : AppColors.textMuted, fontWeight: FontWeight.w700),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              Expanded(child: _WorldSection(index: _section)),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorldSection extends StatelessWidget {
  const _WorldSection({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return switch (index) {
      0 => const _Overview(),
      1 => const _ChatOnly(),
      2 => const _RankOnly(),
      3 => const _ChallengeOnly(),
      _ => const _FriendsOnly(),
    };
  }
}

class _Overview extends StatelessWidget {
  const _Overview();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 800;
            const league = _LeagueCard();
            const challenge = _ChallengeCard();
            if (!wide) return const Column(children: [league, SizedBox(height: 14), challenge]);
            return const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 6, child: league), SizedBox(width: 14), Expanded(flex: 4, child: challenge)]);
          },
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 800;
            const chat = _ChatRoomsCard();
            const rank = _LeaderboardCard();
            if (!wide) return const Column(children: [chat, SizedBox(height: 14), rank]);
            return const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: chat), SizedBox(width: 14), Expanded(child: rank)]);
          },
        ),
      ],
    );
  }
}

class _LeagueCard extends StatelessWidget {
  const _LeagueCard();

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      gradient: const LinearGradient(colors: [Color(0xFF102D59), Color(0xFF0D1730)]),
      child: Row(
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(colors: [Color(0xFF1F7AFF), Color(0xFF172554)]),
              border: Border.all(color: AppColors.cyan, width: 2),
              boxShadow: const [BoxShadow(color: Color(0x553AD7FF), blurRadius: 28)],
            ),
            child: const Icon(Icons.diamond_rounded, color: AppColors.cyan, size: 58),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('WEEKLY LEAGUE', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w800)),
                SizedBox(height: 5),
                Text('Diamond League', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                SizedBox(height: 12),
                Text('Rank hiện tại: #128', style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(height: 5),
                Text('Còn 340 điểm để lên #127', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard();

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('THỬ THÁCH ĐANG DIỄN RA', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          const Row(children: [Icon(Icons.headphones_rounded, color: AppColors.purpleBright), SizedBox(width: 10), Expanded(child: Text('N3 Listening Sprint', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)))]),
          const SizedBox(height: 8),
          const Text('10 bài nghe • 1 lần thi chính thức', style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 12),
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Thời gian còn lại', style: TextStyle(fontSize: 12, color: AppColors.textMuted)), Text('2d 08h 34m', style: TextStyle(fontWeight: FontWeight.w800))]),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: FilledButton(onPressed: _noop, child: Text('THAM GIA NGAY'))),
        ],
      ),
    );
  }
}

class _ChatRoomsCard extends StatelessWidget {
  const _ChatRoomsCard();

  @override
  Widget build(BuildContext context) {
    const rooms = [
      ('N3 Study Room', '128 online', Icons.school_rounded, AppColors.cyan),
      ('Speaking Practice', '92 online', Icons.mic_rounded, AppColors.purpleBright),
      ('Vietnamese Learners', '256 online', Icons.flag_rounded, AppColors.red),
    ];

    return GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PHÒNG CHAT NỔI BẬT', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          ...rooms.map((room) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(width: 42, height: 42, decoration: BoxDecoration(color: room.$4.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), child: Icon(room.$3, color: room.$4)),
                title: Text(room.$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(room.$2),
                trailing: IconButton(onPressed: _noop, icon: const Icon(Icons.chat_bubble_outline_rounded)),
              )),
        ],
      ),
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  const _LeaderboardCard();

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('BẢNG XẾP HẠNG TUẦN', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ...weeklyTop.map((entry) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(color: entry.isCurrentUser ? AppColors.purple.withOpacity(0.18) : Colors.transparent, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    SizedBox(width: 46, child: Text('#${entry.rank}', style: TextStyle(color: entry.rank <= 3 ? AppColors.gold : AppColors.purpleBright, fontWeight: FontWeight.w900))),
                    Expanded(child: Text(entry.name, style: const TextStyle(fontWeight: FontWeight.w700))),
                    Text('${entry.score}', style: const TextStyle(fontWeight: FontWeight.w800)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _ChatOnly extends StatelessWidget {
  const _ChatOnly();

  @override
  Widget build(BuildContext context) => const ListView(children: [_ChatRoomsCard()]);
}

class _RankOnly extends StatelessWidget {
  const _RankOnly();

  @override
  Widget build(BuildContext context) => const ListView(children: [_LeagueCard(), SizedBox(height: 14), _LeaderboardCard()]);
}

class _ChallengeOnly extends StatelessWidget {
  const _ChallengeOnly();

  @override
  Widget build(BuildContext context) => const ListView(children: [_ChallengeCard()]);
}

class _FriendsOnly extends StatelessWidget {
  const _FriendsOnly();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        GamePanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('BẠN BÈ', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w800)),
              SizedBox(height: 14),
              ListTile(contentPadding: EdgeInsets.zero, leading: CircleAvatar(child: Icon(Icons.person)), title: Text('Minh'), subtitle: Text('N3 • Diamond III • đang học'), trailing: Icon(Icons.circle, color: AppColors.green, size: 10)),
              ListTile(contentPadding: EdgeInsets.zero, leading: CircleAvatar(child: Icon(Icons.person)), title: Text('Yuki'), subtitle: Text('N2 • Master V'), trailing: Icon(Icons.circle, color: AppColors.green, size: 10)),
              ListTile(contentPadding: EdgeInsets.zero, leading: CircleAvatar(child: Icon(Icons.person)), title: Text('Kaito'), subtitle: Text('N3 • Diamond II'), trailing: Icon(Icons.circle, color: AppColors.textDim, size: 10)),
            ],
          ),
        ),
      ],
    );
  }
}

void _noop() {}
