import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_keys.dart';
import '../models/cast_member.dart';
import '../models/movie.dart';
import '../models/person.dart';

class TmdbService {
  static const _baseUrl = 'https://api.themoviedb.org/3';

  // Generic request: returns the JSON object of a TMDB endpoint
  Future<Map<String, dynamic>> _getJson(
    String path,
    String language, {
    int page = 1,
  }) async {
    final uri = Uri.parse('$_baseUrl/$path').replace(
      queryParameters: {'language': language, 'page': '$page'},
    );

    final response = await http.get(
      uri,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer ${ApiKeys.tmdbToken}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Errore TMDB: ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  bool _isEmpty(dynamic text) => (text ?? '').toString().trim().isEmpty;

  // Downloads one list and fills missing Italian overviews with the English ones
  Future<List<Movie>> _fetch(
    String path, {
    required bool isSeries,
    int page = 1,
  }) async {
    final json = await _getJson(path, 'it-IT', page: page);
    final results = (json['results'] as List).cast<Map<String, dynamic>>();

    if (results.any((j) => _isEmpty(j['overview']))) {
      try {
        final en = await _getJson(path, 'en-US', page: page);
        final overviews = {
          for (final j in (en['results'] as List).cast<Map<String, dynamic>>())
            j['id']: j['overview'],
        };

        for (final j in results) {
          if (_isEmpty(j['overview'])) {
            j['overview'] = overviews[j['id']] ?? '';
          }
        }
      } catch (_) {
        // If the English request fails, keep the Italian lists
      }
    }

    return results.map((j) => Movie.fromJson(j, isSeries: isSeries)).toList();
  }

  // The 6 API calls
  Future<List<Movie>> getPopularMovies({int page = 1}) =>
      _fetch('movie/popular', isSeries: false, page: page);

  Future<List<Movie>> getPopularSeries({int page = 1}) =>
      _fetch('tv/popular', isSeries: true, page: page);

  Future<List<Movie>> getUpcomingMovies({int page = 1}) =>
      _fetch('movie/upcoming', isSeries: false, page: page);

  Future<List<Movie>> getOnTheAirSeries({int page = 1}) =>
      _fetch('tv/on_the_air', isSeries: true, page: page);

  Future<List<Movie>> getTopRatedMovies({int page = 1}) =>
      _fetch('movie/top_rated', isSeries: false, page: page);

  Future<List<Movie>> getTopRatedSeries({int page = 1}) =>
      _fetch('tv/top_rated', isSeries: true, page: page);

  // Cast of a single movie or series (first 15 actors)
  Future<List<CastMember>> getCast(Movie movie) async {
    final type = movie.isSeries ? 'tv' : 'movie';
    final json = await _getJson('$type/${movie.id}/credits', 'it-IT');
    final cast = (json['cast'] as List).cast<Map<String, dynamic>>();
    return cast.take(15).map(CastMember.fromJson).toList();
  }

  // Actor details; if the Italian biography is empty, uses the English one
  Future<Person> getPerson(int id) async {
    final json = await _getJson('person/$id', 'it-IT');

    if (_isEmpty(json['biography'])) {
      try {
        final en = await _getJson('person/$id', 'it-IT');
        json['biography'] = en['biography'] ?? '';
      } catch (_) {
        // Keep the empty biography
      }
    }
    return Person.fromJson(json);
  }

  // Movies and series of an actor, most popular first (max 15)
  Future<List<Movie>> getPersonCredits(int id) async {
    final json = await _getJson('person/$id/combined_credits', 'it-IT');

    final cast = (json['cast'] as List)
        .cast<Map<String, dynamic>>()
        .where((j) => j['poster_path'] != null)
        .toList()
      ..sort(
        (a, b) => ((b['popularity'] ?? 0) as num)
            .compareTo((a['popularity'] ?? 0) as num),
      );

    return cast
        .take(15)
        .map((j) => Movie.fromJson(j, isSeries: j['media_type'] == 'tv'))
        .toList();
  }
} //