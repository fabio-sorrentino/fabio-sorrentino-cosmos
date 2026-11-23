import 'package:flutter/material.dart';

import '../models/movie.dart';

class MoviePoster extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const MoviePoster({super.key, required this.movie, this.onTap});

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
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: movie.posterUrl != null
              ? Image.network(
                  movie.posterUrl!,
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