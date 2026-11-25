import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie.dart';

class UserListsProvider extends ChangeNotifier {
  // Each list is a map: the key identifies the title, the value is the movie.
  // A map avoids duplicates and keeps the insertion order.
  final Map<String, Movie> _favorites = {};
  final Map<String, Movie> _watchlist = {};
  final Map<String, Movie> _seen = {};

  // Email of the logged-in user: keeps each user's data separate
  String? _userKey;

  // A movie and a series can share the same TMDB id,
  // so the key also includes the type
  String _key(Movie m) => '${m.isSeries ? 'tv' : 'movie'}_${m.id}';

  // Lists used by the screens
  List<Movie> get favorites => _favorites.values.toList();
  List<Movie> get watchlist => _watchlist.values.toList();
  List<Movie> get seen => _seen.values.toList();

  // Counters used by the Profile screen
  int get favoritesCount => _favorites.length;
  int get seenMoviesCount => _seen.values.where((m) => !m.isSeries).length;
  int get seenSeriesCount => _seen.values.where((m) => m.isSeries).length;

  // Checks: is this title in the list?
  bool isFavorite(Movie m) => _favorites.containsKey(_key(m));
  bool isInWatchlist(Movie m) => _watchlist.containsKey(_key(m));
  bool isSeen(Movie m) => _seen.containsKey(_key(m));

  // Actions: add the title if missing, remove it if already there
  void toggleFavorite(Movie m) => _toggle('favorites', _favorites, m);
  void toggleWatchlist(Movie m) => _toggle('watchlist', _watchlist, m);
  void toggleSeen(Movie m) => _toggle('seen', _seen, m);

  void _toggle(String name, Map<String, Movie> list, Movie m) {
    final key = _key(m);
    if (list.containsKey(key)) {
      list.remove(key);
    } else {
      list[key] = m;
    }
    notifyListeners(); // refresh the screens
    _save(name, list); // persist the change on the device
  }

  // Call after a successful login: loads the saved lists of that user
  Future<void> loadForUser(String email) async {
    _userKey = email;
    final prefs = await SharedPreferences.getInstance();
    _load(prefs, 'favorites', _favorites);
    _load(prefs, 'watchlist', _watchlist);
    _load(prefs, 'seen', _seen);
    notifyListeners();
  }

  // Call on logout: empties the app memory, saved data stays on the device
  void clear() {
    _userKey = null;
    _favorites.clear();
    _watchlist.clear();
    _seen.clear();
    notifyListeners();
  }

  // Reads one saved list from the device into the given map
  void _load(SharedPreferences prefs, String name, Map<String, Movie> target) {
    target.clear();
    final raw = prefs.getString('${_userKey}_$name');
    if (raw == null) return;

    try {
      for (final item in jsonDecode(raw) as List) {
        final movie = Movie.fromStoredJson(item as Map<String, dynamic>);
        target[_key(movie)] = movie;
      }
    } catch (_) {
      // Corrupted data: start again from an empty list
    }
  }

  // Writes one list to the device as JSON text
  Future<void> _save(String name, Map<String, Movie> list) async {
    if (_userKey == null) return;
    final prefs = await SharedPreferences.getInstance();
    final text = jsonEncode(list.values.map((m) => m.toJson()).toList());
    await prefs.setString('${_userKey}_$name', text);
  }
}