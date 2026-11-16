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
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          //operatore ternario con index
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: 'Catalogo'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'Lista'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: 'Profilo'),
        ],
      ),
    );
  }
}