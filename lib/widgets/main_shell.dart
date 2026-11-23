import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/catalog_screen.dart';
import '../screens/watchlist_screen.dart';
import '../screens/profile_screen.dart';
import '../theme/app_theme.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _pages = const [
    HomeScreen(),
    CatalogScreen(),
    WatchlistScreen(),
    ProfileScreen(),
  ];
//Icons
  static const _items = [
    (Icons.home_outlined, Icons.home, 'Home'),
    (Icons.search_outlined, Icons.search, 'Catalogo'),
    (Icons.bookmark_border, Icons.bookmark, 'Lista'),
    (Icons.person_outlined, Icons.person, 'Profilo'),
  ];
//Bottom Navigation Bar
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final barColor = dark
        ? AppColors.disabledPrimary
        : AppColors.disabledSurfaceLight;
    final activeBg = dark ? AppColors.secondary : AppColors.tertiary;
    final iconColor = dark ? AppColors.lightBg : AppColors.primary;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Container(
              height: 83,
              color: barColor.withValues(alpha: 0.8),
              child: Row(
                children: List.generate(_items.length, (i) {
                  final selected = i == _index;
                  final item = _items[i];
                  return Expanded(
                    child: Semantics(
                      button: true,
                      selected: selected,
                      label: item.$3,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() => _index = i),
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 54,
                            height: 54,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selected ? activeBg : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              selected ? item.$2 : item.$1,
                              color: iconColor,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
