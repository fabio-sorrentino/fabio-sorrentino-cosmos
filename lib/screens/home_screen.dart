import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../providers/movies_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/movie_poster.dart';
import '../widgets/primary_button.dart';
import '../screens/detail_screen.dart';
import '../screens/favorites_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 6,
        title: Row(
          children: [
            Image.asset('assets/images/cosmos-logo.png', height: 40),
            const SizedBox(width: 8),
            const Text('Home'),
          ],
        ),
      ),
    );
  }
}
