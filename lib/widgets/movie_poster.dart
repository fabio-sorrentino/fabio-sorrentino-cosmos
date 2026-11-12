import 'package:flutter/material.dart';

import '../models/movie.dart';

class MoviePoster extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const MoviePoster({super.key, required this.movie, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: movie.posterUrl != null
            ? Image.network(
                movie.posterUrl!,
                fit:BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: Center(child: Text(movie.title)),
                  );
                },
              )
            : Container(
                color: Theme.of(context).colorScheme.surface,
                child: Center(child: Text(movie.title)),
              ),
      ),
    );
  }
}
