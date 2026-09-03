import 'package:flutter/material.dart';

import '../../features/ability/ability_scene.dart';
import '../../features/home/home_scene.dart';
import '../../features/roadmap/roadmap_scene.dart';
import '../../features/settings/settings_scene.dart';
import '../../features/world/world_scene.dart';
import '../theme/app_colors.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _destinations = [
    _Destination(Icons.home_rounded, 'Trang chủ'),
    _Destination(Icons.map_rounded, 'Lộ trình'),
    _Destination(Icons.mic_rounded, 'Kỹ năng'),
    _Destination(Icons.public_rounded, 'Thế giới'),
    _Destination(Icons.settings_rounded, 'Cài đặt'),
  ];

  final _scenes = const [
    HomeScene(),
    RoadmapScene(),
    AbilityScene(),
    WorldScene(),
    SettingsScene(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 980;

        if (useRail) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _index,
                  onDestinationSelected: (value) => setState(() => _index = value),
                  labelType: NavigationRailLabelType.all,
                  leading: const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 20),
                    child: _BrandMark(),
                  ),
                  destinations: _destinations
                      .map(
                        (item) => NavigationRailDestination(
                          icon: Icon(item.icon),
                          selectedIcon: Icon(item.icon, color: AppColors.purpleBright),
                          label: Text(item.label),
                        ),
                      )
                      .toList(growable: false),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: IndexedStack(index: _index, children: _scenes),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: IndexedStack(index: _index, children: _scenes),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (value) => setState(() => _index = value),
            destinations: _destinations
                .map(
                  (item) => NavigationDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.icon, color: AppColors.purpleBright),
                    label: item.label,
                  ),
                )
                .toList(growable: false),
          ),
        );
      },
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppColors.purple, AppColors.blue],
        ),
      ),
      alignment: Alignment.center,
      child: const Text(
        '日',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _Destination {
  const _Destination(this.icon, this.label);

  final IconData icon;
  final String label;
}
