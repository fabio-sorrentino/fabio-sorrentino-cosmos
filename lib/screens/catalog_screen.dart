import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../models/movie.dart';
import '../providers/movies_provider.dart';
import '../widgets/movie_poster.dart';
import '../widgets/primary_button.dart';
import 'detail_screen.dart';

const _types = ['Tutti', 'Film', 'Serie TV'];
const _categories = ['Popolari', 'In uscita', 'Più votati'];

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  int _type = 0; // posizione in _types
  int _category = 0; // posizione in _categories
  String _query = '';

  // Applica categoria, tipo e ricerca
  List<Movie> _visibleMovies(MoviesProvider p) {
    final movies = [
      p.popularMovies,
      p.upcomingMovies,
      p.topRatedMovies,
    ][_category];
    final series = [
      p.popularSeries,
      p.onTheAirSeries,
      p.topRatedSeries,
    ][_category];
    final list = [
      [...movies, ...series],
      movies,
      series,
    ][_type];

    final q = _query.trim().toLowerCase();
    return list.where((m) => m.title.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final movies = context.watch<MoviesProvider>();
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dark = Theme.of(context).brightness == Brightness.dark;

    // Barra di ricerca
    final searchBg = dark
        ? AppColors.disabledPrimary
        : AppColors.disabledSurfaceLight;
    final searchBorder = dark ? AppColors.lightBg : AppColors.disabledPrimary;
    final searchHint = dark ? AppColors.lightBg : AppColors.primary;
    final searchText = dark ? AppColors.white : AppColors.primary;

    // Chip e pulsante filtri
    final chipBg = dark ? AppColors.disabledPrimary : AppColors.lightBg;
    final chipFg = dark ? AppColors.lightBg : AppColors.primary;
    final chipSelBg = dark ? AppColors.activeTertiary : AppColors.activeTertiary;

    if (movies.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (movies.errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(movies.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Riprova',
                onPressed: () => context.read<MoviesProvider>().loadAll(),
              ),
            ],
          ),
        ),
      );
    }

    final visible = _visibleMovies(movies);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('Catalogo · ${_categories[_category]}'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // Barra di ricerca
            const SizedBox(height: 18),
            TextField(
              onChanged: (value) => setState(() => _query = value),
              style: TextStyle(color: searchText),
              decoration: InputDecoration(
                hintText: 'Cerca film o serie tv ...',
                hintStyle: TextStyle(color: searchHint),
                prefixIcon: Icon(Icons.search, color: searchHint),
                filled: true,
                fillColor: searchBg,
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: searchBorder, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: searchBorder, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Chip del tipo + menu delle categorie
            Row(
              children: [
                for (var i = 0; i < _types.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_types[i]),
                      selected: _type == i,
                      showCheckmark: false,
                      color: WidgetStateProperty.resolveWith(
                        (states) => states.contains(WidgetState.selected)
                            ? chipSelBg
                            : chipBg,
                      ),
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                      labelStyle: TextStyle(
                        color: _type == i ? AppColors.primary : chipFg,
                        fontWeight: FontWeight.w700,
                      ),
                      onSelected: (_) => setState(() => _type = i),
                    ),
                  ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: PopupMenuButton<int>(
                    tooltip: 'Filtri',
                    icon: Icon(Icons.tune, color: chipFg),
                    onSelected: (i) => setState(() => _category = i),
                    itemBuilder: (_) => [
                      for (var i = 0; i < _categories.length; i++)
                        PopupMenuItem(value: i, child: Text(_categories[i])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Griglia di locandine
            Expanded(
              child: visible.isEmpty
                  ? Center(
                      child: Text(
                        'Nessun risultato',
                        style: textTheme.bodyMedium,
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2 / 3,
                          ),
                      itemCount: visible.length,
                      itemBuilder: (context, i) => MoviePoster(
                        movie: visible[i],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(movie: visible[i]),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
