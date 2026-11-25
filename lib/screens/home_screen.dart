import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../models/movie.dart';
import '../providers/movies_provider.dart';
import '../widgets/movie_poster.dart';
import '../screens/detail_screen.dart';
import '../screens/favorites_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openDetail(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(movie: movie)),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _section(BuildContext context, String title, List<Movie> movies) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(title),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length > 10 ? 10 : movies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final movie = movies[i];
              return SizedBox(
                width: 120,
                child: MoviePoster(
                  movie: movie,
                  onTap: () => _openDetail(context, movie),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MoviesProvider>();
    final popularMovies = provider.popularMovies;
    final popularSeries = provider.popularSeries;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = dark ? AppColors.white : AppColors.primary;

    //Big card movie (temporary): null if the list is too short
    final Movie? featured = popularMovies.length > 1 ? popularMovies[1] : null;

    final noData = popularMovies.isEmpty && popularSeries.isEmpty;

    Widget body;
    if (provider.isLoading && noData) {
      body = const Center(child: CircularProgressIndicator());
    } else if (provider.errorMessage != null && noData) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(provider.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<MoviesProvider>().loadAll(),
                child: const Text('Riprova'),
              ),
            ],
          ),
        ),
      );
    } else {
      body = SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (featured != null) ...[
              _sectionTitle('Continua a guardare'),
              const SizedBox(height: 12),
              MoviePoster(
                movie: featured,
                useBackdrop: true,
                aspectRatio: 16 / 9,
                radius: 20,
                onTap: () => _openDetail(context, featured),
              ),
              const SizedBox(height: 24),
            ],
            _section(context, 'Film più visti', popularMovies),
            const SizedBox(height: 24),
            _section(context, 'Serie più viste', popularSeries),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 24,
        title: Row(
          children: [
            Image.asset('assets/images/cosmos-logo.png', height: 32),
            const SizedBox(width: 8),
            const Text('COSMOS', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Preferiti',
            icon: Icon(Icons.favorite_border, color: iconColor),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesScreen()),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: body,
    );
  }
}
