import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/game_panel.dart';

class LearningSessionScreen extends StatefulWidget {
  const LearningSessionScreen({super.key});

  @override
  State<LearningSessionScreen> createState() => _LearningSessionScreenState();
}

class _LearningSessionScreenState extends State<LearningSessionScreen> {
  int? _selected;
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    final answers = ['Đi ngủ sớm', 'Đi làm sớm', 'Phải học tối nay', 'Không cần học'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('N3 • Bài 04 • Chương 03'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: Center(child: Text('6 / 12')),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const LinearProgressIndicator(
                  value: 0.5,
                  minHeight: 6,
                  color: AppColors.purpleBright,
                  backgroundColor: AppColors.borderSoft,
                ),
                const SizedBox(height: 28),
                const Text('Listening', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                const Text(
                  '聞いて、最も自然な意味を選んでください。',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 20),
                GamePanel(
                  child: Row(
                    children: [
                      IconButton.filled(
                        onPressed: () {},
                        icon: const Icon(Icons.play_arrow_rounded),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: LinearProgressIndicator(
                          value: 0.34,
                          minHeight: 5,
                          color: AppColors.cyan,
                          backgroundColor: AppColors.borderSoft,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('0:08'),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                ...List.generate(answers.length, (index) {
                  final selected = _selected == index;
                  final correct = index == 2;
                  Color border = AppColors.border;
                  if (_checked && selected) border = correct ? AppColors.green : AppColors.red;
                  if (!_checked && selected) border = AppColors.purpleBright;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GamePanel(
                      borderColor: border,
                      onTap: _checked ? null : () => setState(() => _selected = index),
                      child: Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selected ? AppColors.purple.withOpacity(0.22) : AppColors.panelAlt,
                            ),
                            alignment: Alignment.center,
                            child: Text(String.fromCharCode(65 + index)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(child: Text(answers[index], style: const TextStyle(fontSize: 15))),
                        ],
                      ),
                    ),
                  );
                }),
                if (_checked) ...[
                  const SizedBox(height: 8),
                  Text(
                    _selected == 2
                        ? 'Chính xác. Ý chính là người nói phải học tối nay.'
                        : 'Chưa đúng. Hãy chú ý mẫu ～なければなりません.',
                    style: TextStyle(
                      color: _selected == 2 ? AppColors.green : AppColors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _selected == null
                      ? null
                      : () {
                          if (!_checked) {
                            setState(() => _checked = true);
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                  child: Text(_checked ? 'Hoàn tất mẫu' : 'Kiểm tra'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
