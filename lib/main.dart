import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/movies_provider.dart';
import './theme/app_theme.dart';
import './widgets/movie_poster.dart';
import './widgets/primary_button.dart';
import './widgets/custom_text_field.dart';
import './screens/login_screen.dart';
import './widgets/main_shell.dart';
import './providers/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoviesProvider()..loadAll()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COSMOS CINEMA',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const LoginScreen(),
    );
  }
}

// SCHERMATA TEMPORANEA: serve solo a verificare API e widget, poi la elimini
class ApiTestScreen extends StatelessWidget {
  const ApiTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(16),
        children: [
          Text('Film popolari: ${movies.popularMovies.length}'),
          Text('Serie popolari: ${movies.popularSeries.length}'),
          Text('Film in uscita: ${movies.upcomingMovies.length}'),
          Text('Serie in onda: ${movies.onTheAirSeries.length}'),
          Text('Film top rated: ${movies.topRatedMovies.length}'),
          Text('Serie top rated: ${movies.topRatedSeries.length}'),
          const Divider(),
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final m in movies.popularMovies.take(5))
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: MoviePoster(
                      movie: m,
                      onTap: () => debugPrint('Toccato: ${m.title}'),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Accedi',
            onPressed: () => debugPrint('Bottone premuto'),
          ),
          const SizedBox(height: 8),
          const PrimaryButton(label: 'Disattivato'),
        ],
      ),
    );
  }
}