import './providers/movies_provider.dart';
import './theme/app_theme.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MoviesProvider()..loadAll(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Cosmos Cinema',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const ApiTestScreen(),
    );
  }
}

class ApiTestScreen extends StatelessWidget {
  const ApiTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final movies = context.watch<MoviesProvider>();

    if (movies.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (movies.errorMessage != null) {
      return Scaffold(body: Center(child: Text(movies.errorMessage!)));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Test API')),
      body: ListView(
        children: [
          Text('Popular Movies: ${movies.popularMovies.length}'),
          Text('Popular Series: ${movies.popularSeries.length}'),
          Text('Upcoming Movies: ${movies.upcomingMovies.length}'),
          Text('On the air Series: ${movies.onTheAirSeries.length}'),
          Text('Top rated Movies: ${movies.topRatedMovies.length}'),
          Text('Top rated Series: ${movies.topRatedSeries.length}'),
          const Divider(),
          for (final m in movies.popularMovies.take(6)) Text(m.title),
        ],
      ),
    );
  }
}
