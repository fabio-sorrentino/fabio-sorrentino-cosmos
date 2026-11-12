import 'package:flutter/material.dart';

import '../models/movie.dart';

class MoviePoster extends StatelessWidget {
  // Film o serie TV da visualizzare
  final Movie movie;

  // Funzione facoltativa da eseguire al clic
  final VoidCallback? onTap;

  // Costruttore
  const MoviePoster({
    super.key,
    required this.movie,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      // Proporzioni verticali della locandina
      aspectRatio: 2 / 3,

      child: InkWell(
        // Gestisce il clic sul poster
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),

        child: ClipRRect(
          // Arrotonda gli angoli
          borderRadius: BorderRadius.circular(20),

          child: movie.posterUrl != null
              ? Image.network(
                  // Carica l'immagine da TMDB
                  movie.posterUrl!,

                  // Adatta l'immagine allo spazio disponibile
                  fit: BoxFit.cover,

                  // Gestisce eventuali errori di caricamento
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: Center(
                        child: Text(
                          movie.title,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                )

              // Se non esiste una locandina
              : Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Center(
                    child: Text(
                      movie.title,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
