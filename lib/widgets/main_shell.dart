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

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final barColor = dark ? AppColors.primary : AppColors.surfaceLight;
    final activeBg = dark ? AppColors.secondary : AppColors.tertiary;
    final iconColor = dark ? AppColors.lightBg : AppColors.primary;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: NavigationBar(
            height: 83,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            backgroundColor: barColor.withValues(alpha: 0.8),
            indicatorColor: activeBg,
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: iconColor, size: 32),
                selectedIcon: Icon(Icons.home, color: iconColor, size: 32),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.search_outlined, color: iconColor, size: 32),
                selectedIcon: Icon(Icons.search, color: iconColor, size: 32),
                label: 'Catalogo',
              ),
              NavigationDestination(
                icon: Icon(Icons.bookmark_border, color: iconColor, size: 32),
                selectedIcon: Icon(Icons.bookmark, color: iconColor, size: 32),
                label: 'Lista',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outlined, color: iconColor, size: 32),
                selectedIcon: Icon(Icons.person, color: iconColor, size: 32),
                label: 'Profilo',
              ),
            ],
          ),
        ),
      ),
    );
  }
}