import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/movie.dart';
import '../providers/user_lists_provider.dart';
import '../widgets/primary_button.dart';
import '../widgets/cast_section.dart';
import '../widgets/skeleton.dart';

class DetailScreen extends StatelessWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final lists = context.watch<UserListsProvider>();
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isFavorite = lists.isFavorite(movie);
    final isSeen = lists.isSeen(movie);
    final inWatchlist = lists.isInWatchlist(movie);

    final year = (movie.releaseDate != null && movie.releaseDate!.length >= 4)
        ? movie.releaseDate!.substring(0, 4)
        : null;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('Dettaglio', style: textTheme.titleMedium),
        actions: [
          IconButton(
            tooltip: isFavorite
                ? 'Togli dai preferiti'
                : 'Aggiungi ai preferiti',
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () =>
                context.read<UserListsProvider>().toggleFavorite(movie),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Center(
            child: SizedBox(
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: movie.posterUrl != null
                    ? CachedNetworkImage(
                        imageUrl: movie.posterUrl!,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 250),
                        placeholder: (context, url) => const Skeleton(),
                        errorWidget: (context, url, error) =>
                            _NoPoster(movie.title),
                      )
                    : _NoPoster(movie.title),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(movie.title, style: textTheme.titleLarge),
          const SizedBox(height: 8),

          Row(
            children: [
              _Tag(movie.isSeries ? 'Serie TV' : 'Film'),
              if (year != null) ...[
                const SizedBox(width: 10),
                Text(year, style: textTheme.bodySmall),
              ],
              const SizedBox(width: 10),
              Icon(Icons.star, size: 16, color: scheme.primary),
              const SizedBox(width: 4),
              Text(
                movie.voteAverage.toStringAsFixed(1),
                style: textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            movie.overview.isEmpty ? 'Trama non disponibile' : movie.overview,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 28),
          const SizedBox(height: 24),
          CastSection(movie: movie),
          const SizedBox(height: 28),

          PrimaryButton(
            label: isSeen ? 'Visto ✓' : 'Segna come visto',
            onPressed: () =>
                context.read<UserListsProvider>().toggleSeen(movie),
          ),
          const SizedBox(height: 12),

          Center(
            child: TextButton.icon(
              onPressed: () =>
                  context.read<UserListsProvider>().toggleWatchlist(movie),
              icon: Icon(
                inWatchlist ? Icons.bookmark : Icons.bookmark_border,
                color: scheme.onSurface,
              ),
              label: Text(
                inWatchlist ? 'Nella watchlist' : 'Aggiungi alla watchlist',
                style: TextStyle(color: scheme.onSurface),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoPoster extends StatelessWidget {
  final String title;

  const _NoPoster(this.title);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.all(12),
        alignment: Alignment.center,
        child: Text(title, textAlign: TextAlign.center),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;

  const _Tag(this.label);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: scheme.onPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
