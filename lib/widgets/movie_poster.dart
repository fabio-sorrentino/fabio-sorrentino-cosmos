import 'package:flutter/material.dart';

import '../models/movie.dart';

class MoviePoster extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;
  final bool useBackdrop;
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

  // Reserve box, written only once
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
    final url = useBackdrop
        ? (movie.backdropUrl ?? movie.posterUrl)
        : movie.posterUrl;

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: url != null
              ? Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _placeholder(context),
                )
              : _placeholder(context),
        ),
      ),
    );
  }
}