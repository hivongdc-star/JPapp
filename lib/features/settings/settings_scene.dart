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
  bool _reviewReminder = true;
  bool _furigana = false;
  bool _autoAudio = true;

  @override
  Widget build(BuildContext context) {
    return SceneScaffold(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: ListView(
            children: [
              const Text('Cài đặt', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
              const SizedBox(height: 16),
              const _AccountCard(),
              const SizedBox(height: 14),
              const _AccountStats(),
              const SizedBox(height: 14),
              GamePanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('THIẾT LẬP NHANH', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    _ToggleTile(
                      icon: Icons.notifications_active_rounded,
                      title: 'Nhắc nhở ôn tập',
                      subtitle: 'Nhắc khi review queue đến hạn',
                      value: _reviewReminder,
                      onChanged: (value) => setState(() => _reviewReminder = value),
                    ),
                    _ToggleTile(
                      icon: Icons.graphic_eq_rounded,
                      title: 'Tự động phát audio',
                      subtitle: 'Phát audio khi mở bài Listening',
                      value: _autoAudio,
                      onChanged: (value) => setState(() => _autoAudio = value),
                    ),
                    _ToggleTile(
                      icon: Icons.translate_rounded,
                      title: 'Hiển thị Furigana',
                      subtitle: 'Mặc định ẩn để tránh phụ thuộc cách đọc',
                      value: _furigana,
                      onChanged: (value) => setState(() => _furigana = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const _SettingsMenu(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context) {
    const avatar = _SettingsAvatar();
    const identity = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hikari', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          SizedBox(height: 4),
          Text('hikari.jp@example.com', style: TextStyle(color: AppColors.textMuted)),
          SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.workspace_premium_rounded, color: AppColors.gold, size: 18),
              SizedBox(width: 5),
              Text('Diamond League', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );

    return GamePanel(
      gradient: const LinearGradient(colors: [Color(0xFF121E36), Color(0xFF0C172B)]),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 520) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(children: [avatar, SizedBox(width: 16), identity]),
                const SizedBox(height: 14),
                OutlinedButton(onPressed: _noop, child: const Text('Quản lý tài khoản')),
              ],
            );
          }

          return Row(
            children: [
              avatar,
              const SizedBox(width: 16),
              identity,
              const SizedBox(width: 12),
              OutlinedButton(onPressed: _noop, child: const Text('Quản lý')),
            ],
          );
        },
      ),
    );
  }
}

class _SettingsAvatar extends StatelessWidget {
  const _SettingsAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(colors: [AppColors.purple, AppColors.blue]),
        border: Border.all(color: AppColors.purpleBright, width: 2),
      ),
      child: const Icon(Icons.person_rounded, size: 48),
    );
  }
}

class _AccountStats extends StatelessWidget {
  const _AccountStats();

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth < 650 ? (constraints.maxWidth - 12) / 2 : (constraints.maxWidth - 48) / 5;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: stats.map((stat) => SizedBox(width: width, child: Column(children: [Text(stat.$1, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(stat.$2, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted, fontSize: 11))]))).toList(growable: false),
          );
        },
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({required this.icon, required this.title, required this.subtitle, required this.value, required this.onChanged});

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: Icon(icon, color: AppColors.purpleBright),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}

class _SettingsMenu extends StatelessWidget {
  const _SettingsMenu();

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.school_rounded, 'Học tập'),
      (Icons.record_voice_over_rounded, 'Âm thanh & Giọng nói'),
      (Icons.palette_rounded, 'Giao diện'),
      (Icons.language_rounded, 'Ngôn ngữ'),
      (Icons.download_rounded, 'Dữ liệu & Tải xuống'),
      (Icons.lock_rounded, 'Quyền riêng tư'),
      (Icons.info_rounded, 'Giới thiệu'),
    ];

    return GamePanel(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Column(
        children: items.map((item) => ListTile(contentPadding: EdgeInsets.zero, leading: Icon(item.$1, color: AppColors.textMuted), title: Text(item.$2, style: const TextStyle(fontWeight: FontWeight.w600)), trailing: const Icon(Icons.chevron_right_rounded), onTap: _noop)).toList(growable: false),
      ),
    );
  }
}

void _noop() {}
