import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/game_panel.dart';
import '../../core/widgets/scene_scaffold.dart';

class SettingsScene extends StatefulWidget {
  const SettingsScene({super.key});

  @override
  State<SettingsScene> createState() => _SettingsSceneState();
}

class _SettingsSceneState extends State<SettingsScene> {
  int _section = 0;
  bool _reviewReminder = false;
  bool _autoAudio = false;
  bool _furiganaSmart = true;
  bool _dailyGoal = true;

  static const _sections = [
    (Icons.person_rounded, 'Tài khoản'),
    (Icons.school_rounded, 'Học tập'),
    (Icons.graphic_eq_rounded, 'Âm thanh & Giọng nói'),
    (Icons.palette_rounded, 'Giao diện'),
    (Icons.notifications_active_rounded, 'Thông báo'),
    (Icons.download_rounded, 'Dữ liệu & Tải xuống'),
    (Icons.language_rounded, 'Ngôn ngữ'),
    (Icons.lock_rounded, 'Quyền riêng tư'),
    (Icons.info_rounded, 'Giới thiệu'),
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
              final content = ListView(
                children: [
                  const _AccountHeader(),
                  const SizedBox(height: 16),
                  const _AccountStatsPanel(),
                  const SizedBox(height: 16),
                  _QuickSettingsGrid(
                    dailyGoal: _dailyGoal,
                    reviewReminder: _reviewReminder,
                    autoAudio: _autoAudio,
                    furiganaSmart: _furiganaSmart,
                    onDailyGoalChanged: (value) => setState(() => _dailyGoal = value),
                    onReviewReminderChanged: (value) => setState(() => _reviewReminder = value),
                    onAutoAudioChanged: (value) => setState(() => _autoAudio = value),
                    onFuriganaSmartChanged: (value) => setState(() => _furiganaSmart = value),
                  ),
                ],
              );

              if (!useSidebar) {
                return Column(
                  children: [
                    SizedBox(
                      height: 44,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final selected = _section == index;
                          return ChoiceChip(
                            selected: selected,
                            label: Text(_sections[index].$2),
                            onSelected: (_) => setState(() => _section = index),
                            selectedColor: AppColors.purple.withOpacity(0.22),
                            side: BorderSide(color: selected ? AppColors.purple : AppColors.borderSoft),
                            labelStyle: TextStyle(color: selected ? AppColors.purpleBright : AppColors.textMuted, fontWeight: FontWeight.w700),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemCount: _sections.length,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(child: content),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 240,
                    child: _SettingsSidebar(
                      selectedIndex: _section,
                      onSelect: (index) => setState(() => _section = index),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: content),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SettingsSidebar extends StatelessWidget {
  const _SettingsSidebar({required this.selectedIndex, required this.onSelect});

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_SettingsSceneState._sections.length, (index) {
          final item = _SettingsSceneState._sections[index];
          final selected = index == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => onSelect(index),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? AppColors.purple.withOpacity(0.18) : Colors.transparent,
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
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader();

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF111B36), Color(0xFF0A1223)],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = constraints.maxWidth < 640;
          final profile = Row(
            children: [
              const _ProfileAvatar(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Text('Hikari', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                        SizedBox(width: 6),
                        Icon(Icons.edit_rounded, color: AppColors.textMuted, size: 15),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text('hikari.jp@example.com', style: TextStyle(color: AppColors.textMuted)),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.workspace_premium_rounded, color: AppColors.gold, size: 18),
                        SizedBox(width: 6),
                        Text('Thành viên Pro', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );

          final action = OutlinedButton(onPressed: () {}, child: const Text('Quản lý'));

          if (narrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                profile,
                const SizedBox(height: 16),
                action,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: profile),
              const SizedBox(width: 16),
              action,
            ],
          );
        },
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(colors: [Color(0xFF32406B), Color(0xFF0D1525)]),
        border: Border.all(color: Colors.white.withOpacity(0.16), width: 1.6),
      ),
      child: const Icon(Icons.person_rounded, color: Colors.white, size: 52),
    );
  }
}

class _AccountStatsPanel extends StatelessWidget {
  const _AccountStatsPanel();

  @override
  Widget build(BuildContext context) {
    const stats = [
      ('27', 'Cấp độ'),
      ('128', 'Rank hiện tại'),
      ('186', 'Ngày học'),
      ('512', 'Chapter đã hoàn thành'),
      ('92%', 'Tỉ lệ đúng TB'),
    ];

    return GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('THỐNG KÊ TÀI KHOẢN', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 760 ? 5 : 2;
              final width = (constraints.maxWidth - ((columns - 1) * 12)) / columns;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: stats
                    .map(
                      (stat) => SizedBox(
                        width: width,
                        child: Column(
                          children: [
                            Text(stat.$1, style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 6),
                            Text(stat.$2, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                          ],
                        ),
                      ),
                    )
                    .toList(growable: false),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QuickSettingsGrid extends StatelessWidget {
  const _QuickSettingsGrid({
    required this.dailyGoal,
    required this.reviewReminder,
    required this.autoAudio,
    required this.furiganaSmart,
    required this.onDailyGoalChanged,
    required this.onReviewReminderChanged,
    required this.onAutoAudioChanged,
    required this.onFuriganaSmartChanged,
  });

  final bool dailyGoal;
  final bool reviewReminder;
  final bool autoAudio;
  final bool furiganaSmart;
  final ValueChanged<bool> onDailyGoalChanged;
  final ValueChanged<bool> onReviewReminderChanged;
  final ValueChanged<bool> onAutoAudioChanged;
  final ValueChanged<bool> onFuriganaSmartChanged;

  @override
  Widget build(BuildContext context) {
    return GamePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('THIẾT LẬP NHANH', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 900 ? 4 : 2;
              final width = (constraints.maxWidth - ((columns - 1) * 12)) / columns;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: width,
                    child: _QuickSettingCard(
                      icon: Icons.timer_rounded,
                      title: 'Mục tiêu hằng ngày',
                      subtitle: '60 phút',
                      value: dailyGoal,
                      onChanged: onDailyGoalChanged,
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _QuickSettingCard(
                      icon: Icons.notifications_active_rounded,
                      title: 'Nhắc nhở ôn tập',
                      subtitle: reviewReminder ? 'Bật' : 'Tắt',
                      value: reviewReminder,
                      onChanged: onReviewReminderChanged,
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _QuickSettingCard(
                      icon: Icons.wifi_rounded,
                      title: 'Tự động phát audio',
                      subtitle: autoAudio ? 'Chỉ Wi-Fi' : 'Tắt',
                      value: autoAudio,
                      onChanged: onAutoAudioChanged,
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _QuickSettingCard(
                      icon: Icons.translate_rounded,
                      title: 'Hiển thị Furigana',
                      subtitle: furiganaSmart ? 'Thông minh' : 'Ẩn',
                      value: furiganaSmart,
                      onChanged: onFuriganaSmartChanged,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QuickSettingCard extends StatelessWidget {
  const _QuickSettingCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundRaised.withOpacity(0.76),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.panelAlt,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.cyan, size: 18),
              ),
              const Spacer(),
              Switch(value: value, onChanged: onChanged),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
