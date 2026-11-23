import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../providers/user_lists_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/movie_poster.dart';
import 'detail_screen.dart';

const _types = ['Film', 'Serie TV'];

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  int _type = 0; // 0 = Film, 1 = Serie TV

  @override
  Widget build(BuildContext context) {
    final lists = context.watch<UserListsProvider>();
    final textTheme = Theme.of(context).textTheme;
    final dark = Theme.of(context).brightness == Brightness.dark;

    // Stessi colori delle chip del Catalogo
    final chipBg = dark ? AppColors.disabledPrimary : AppColors.lightBg;
    final chipFg = dark ? AppColors.lightBg : AppColors.primary;
    final chipSelBg = dark ? AppColors.activeTertiary : AppColors.activeTertiary;

    final items =
        lists.watchlist.where((m) => m.isSeries == (_type == 1)).toList();

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        titleSpacing: 24,
        title: Text('La mia lista',),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // Chip larghe, una per metà schermo
            const SizedBox(height: 18 ),
            Row(
              children: [
                for (var i = 0; i < _types.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _type = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 46,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _type == i ? chipSelBg : chipBg,
                          borderRadius: BorderRadius.circular(23),
                        ),
                        child: Text(
                          _types[i],
                          style: TextStyle(
                            color: _type == i ? AppColors.primary : chipFg,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),

            // Lista di righe
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        _type == 0
                            ? 'Nessun film nella lista'
                            : 'Nessuna serie nella lista',
                        style: textTheme.bodySmall,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 110),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 24),
                      itemBuilder: (context, i) =>
                          _WatchlistRow(movie: items[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Una riga: locandina a sinistra, titolo e tag a destra
class _WatchlistRow extends StatelessWidget {
  final Movie movie;

  const _WatchlistRow({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(movie: movie)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 84, child: MoviePoster(movie: movie)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: textTheme.bodyMedium?.color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    movie.isSeries ? 'Serie TV' : 'Film',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}