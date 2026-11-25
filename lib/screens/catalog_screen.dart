import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../providers/movies_provider.dart';
import '../theme/app_theme.dart';
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
  int _type = 0; // position in _types
  int _category = 0; // position in _categories
  String _query = '';

  // Apply category, type and search
  List<Movie> _visibleMovies(MoviesProvider p) {
    final movies = [p.popularMovies, p.upcomingMovies, p.topRatedMovies][_category];
    final series = [p.popularSeries, p.onTheAirSeries, p.topRatedSeries][_category];
    final list = [[...movies, ...series], movies, series][_type];

    final q = _query.trim().toLowerCase();
    return list.where((m) => m.title.toLowerCase().contains(q)).toList();
  }

  // Bottom sheet to choose the category
  void _openFilters(Color bg, Color fg, Color selBg) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (sheet) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < _categories.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    shape: const StadiumBorder(),
                    tileColor: _category == i ? selBg : bg,
                    title: Text(
                      _categories[i],
                      style: TextStyle(
                        color: _category == i ? AppColors.primary : fg,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    trailing: _category == i
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      setState(() => _category = i);
                      Navigator.pop(sheet);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movies = context.watch<MoviesProvider>();
    final dark = Theme.of(context).brightness == Brightness.dark;

    // One set of colors for search bar, chips and filter button
    final bg = dark ? AppColors.disabledPrimary : AppColors.lightBg;
    final fg = dark ? AppColors.lightBg : AppColors.primary;
    final selBg = dark ? AppColors.tertiary : AppColors.activeTertiary;
    final searchBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: fg, width: 1.5),
    );

    if (movies.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (movies.errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(movies.errorMessage!),
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
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
        child: Column(
          children: [
            // Search bar
            TextField(
              onChanged: (value) => setState(() => _query = value),
              style: TextStyle(color: fg),
              decoration: InputDecoration(
                hintText: 'Cerca film o serie tv ...',
                hintStyle: TextStyle(color: fg),
                prefixIcon: Icon(Icons.search, color: fg),
                fillColor: dark ? bg : AppColors.disabledSurfaceLight,
                isDense: true,
                enabledBorder: searchBorder,
                focusedBorder: searchBorder,
              ),
            ),
            const SizedBox(height: 12),

            // Type chips + filter button
            Row(
              children: [
                for (var i = 0; i < _types.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_types[i]),
                      selected: _type == i,
                      showCheckmark: false,
                      color: WidgetStatePropertyAll(_type == i ? selBg : bg),
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                      labelStyle: TextStyle(
                        color: _type == i ? AppColors.primary : fg,
                        fontWeight: FontWeight.w700,
                      ),
                      onSelected: (_) => setState(() => _type = i),
                    ),
                  ),
                const Spacer(),
                IconButton(
                  tooltip: 'Filtri',
                  icon: Icon(Icons.tune, color: fg),
                  style: IconButton.styleFrom(
                    backgroundColor: bg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => _openFilters(bg, fg, selBg),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Poster grid
            Expanded(
              child: visible.isEmpty
                  ? const Center(child: Text('Nessun risultato'))
                  : GridView.builder(
                      padding: const EdgeInsets.only(bottom: 110),
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