import 'package:flutter/foundation.dart';
import '../models/movie.dart';

class UserListsProvider extends ChangeNotifier {
  // Ogni lista è una mappa: la chiave identifica il film, il valore è il film.
  // Una mappa evita i doppioni e mantiene l'ordine di inserimento.
  final Map<String, Movie> _favorites = {};
  final Map<String, Movie> _watchlist = {};
  final Map<String, Movie> _seen = {};

  // Un film e una serie possono avere lo stesso id su TMDB,
  // quindi la chiave include anche il tipo
  String _key(Movie m) => '${m.isSeries ? 'tv' : 'movie'}_${m.id}';

  // Liste per le schermate
  List<Movie> get favorites => _favorites.values.toList();
  List<Movie> get watchlist => _watchlist.values.toList();
  List<Movie> get seen => _seen.values.toList();

  // Numeri per le statistiche del Profilo
  int get favoritesCount => _favorites.length;
  int get seenMoviesCount => _seen.values.where((m) => !m.isSeries).length;
  int get seenSeriesCount => _seen.values.where((m) => m.isSeries).length;

  // Domande: "questo film è nella lista?"
  bool isFavorite(Movie m) => _favorites.containsKey(_key(m));
  bool isInWatchlist(Movie m) => _watchlist.containsKey(_key(m));
  bool isSeen(Movie m) => _seen.containsKey(_key(m));

  // Azioni: aggiunge se manca, toglie se c'è
  void toggleFavorite(Movie m) => _toggle(_favorites, m);
  void toggleWatchlist(Movie m) => _toggle(_watchlist, m);
  void toggleSeen(Movie m) => _toggle(_seen, m);

  void _toggle(Map<String, Movie> list, Movie m) {
    final key = _key(m);
    if (list.containsKey(key)) {
      list.remove(key);
    } else {
      list[key] = m;
    }
    notifyListeners();
  }
}