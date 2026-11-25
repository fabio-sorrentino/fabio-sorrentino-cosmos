import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../providers/user_lists_provider.dart';
import '../theme/app_theme.dart';

class MoviePoster extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;

  // Use the wide backdrop image instead of the vertical poster
  final bool useBackdrop;

  // Shape of the widget (default: vertical poster)
  final double aspectRatio;
  final double radius;

  const MoviePoster({
    super.key,
    required this.movie,
    this.onTap,
    this.useBackdrop = false,
    this.aspectRatio = 2 / 3,
    this.radius = 12,
  });

  // Fallback box, written once and used in both cases below
  Widget _placeholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Text(
        movie.title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Rebuilds only when the favorite status of THIS movie changes
    final isFavorite = context.select<UserListsProvider, bool>(
      (lists) => lists.isFavorite(movie),
    );

    // Backdrop if requested and available, otherwise the poster
    final imageUrl =
        useBackdrop ? (movie.backdropUrl ?? movie.posterUrl) : movie.posterUrl;

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _placeholder(context),
                    )
                  : _placeholder(context),

              // Filled heart in the top-right corner for favorites
              if (isFavorite)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      size: 14,
                      color: AppColors.activeLightBg,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}