import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie.dart';

class FavoritesProvider extends ChangeNotifier {
  static const _key = 'favorites';

  final List<Movie> _favorites = [];
  List<Movie> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(Movie movie) =>
      _favorites.any((m) => m.id == movie.id && m.isSeries == movie.isSeries);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    _favorites
      ..clear()
      ..addAll(raw.map((s) {
        final json = jsonDecode(s) as Map<String, dynamic>;
        return Movie.fromJson(json, isSeries: json['is_series'] ?? false);
      }));
    notifyListeners();
  }

  Future<void> toggle(Movie movie) async {
    if (isFavorite(movie)) {
      _favorites.removeWhere(
        (m) => m.id == movie.id && m.isSeries == movie.isSeries,
      );
    } else {
      _favorites.insert(0, movie);
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      _favorites.map((m) => jsonEncode(m.toJson())).toList(),
    );
  }
}