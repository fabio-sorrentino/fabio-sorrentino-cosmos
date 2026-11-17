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
  int? _hoveredIndex;

  final _pages = const [
    HomeScreen(),
    CatalogScreen(),
    WatchlistScreen(),
    ProfileScreen(),
  ];

  // Widget personalizzato per ogni icona
  Widget _buildNavItem(
    int index,
    IconData selectedIcon,
    IconData unselectedIcon,
  ) {
    final bool isSelected = _index == index;
    final bool isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoveredIndex = index;
        });
      },
      onExit: (_) {
        setState(() {
          _hoveredIndex = null;
        });
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            _index = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: isSelected || isHovered
                ? AppColors.secondary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Icon(
              isSelected ? selectedIcon : unselectedIcon,
              size: 35,
              color: AppColors.lightBg,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Container(
          width: double.infinity,
          height: 83,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(35),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNavItem(0, Icons.home, Icons.home_outlined),
              _buildNavItem(1, Icons.search, Icons.search_outlined),
              _buildNavItem(2, Icons.bookmark, Icons.bookmark_border),
              _buildNavItem(3, Icons.person, Icons.person_outlined),
            ],
          ),
        ),
      ),
    );
  }
}
