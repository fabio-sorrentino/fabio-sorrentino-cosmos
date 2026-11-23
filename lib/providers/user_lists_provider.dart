import 'package:flutter/foundation.dart';
import '../models/movie.dart';

class UserListsProvider extends ChangeNotifier {
// Each list is a map: the key identifies the film, and the value is the film itself.
// A map prevents duplicates and maintains the order of insertion.
  final Map<String, Movie> _favorites = {};
  final Map<String, Movie> _watchlist = {};
  final Map<String, Movie> _seen = {};

// A movie and a series can have the same ID on TMDB,
// so the key also includes the type
  String _key(Movie m) => '${m.isSeries ? 'tv' : 'movie'}_${m.id}';

// Lists for the screens
  List<Movie> get favorites => _favorites.values.toList();
  List<Movie> get watchlist => _watchlist.values.toList();
  List<Movie> get seen => _seen.values.toList();

// Numbers for Profile statistics
  int get favoritesCount => _favorites.length;
  int get seenMoviesCount => _seen.values.where((m) => !m.isSeries).length;
  int get seenSeriesCount => _seen.values.where((m) => m.isSeries).length;

// Questions: "is this film on the list?"
  bool isFavorite(Movie m) => _favorites.containsKey(_key(m));
  bool isInWatchlist(Movie m) => _watchlist.containsKey(_key(m));
  bool isSeen(Movie m) => _seen.containsKey(_key(m));

// Actions: adds if missing, removes if present
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