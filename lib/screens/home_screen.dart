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
    return const Scaffold(
      body: SafeArea(child: Center(child: Text('Home'))),
    );
  }
}