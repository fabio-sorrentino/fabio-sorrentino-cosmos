import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_keys.dart';
import '../models/cast_member.dart';
import '../models/movie.dart';

class TmdbService {
  static const _baseUrl = 'https://api.themoviedb.org/3';

  // Downloads a raw list from TMDB in the given language
  Future<List<Map<String, dynamic>>> _getRaw(
    String path, {
    required String language,
    required int page,
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

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['results'] as List).cast<Map<String, dynamic>>();
  }

  bool _isEmpty(dynamic overview) => (overview ?? '').toString().trim().isEmpty;

  Future<List<Movie>> _fetch(
    String path, {
    required bool isSeries,
    int page = 1,
  }) async {
    final results = await _getRaw(path, language: 'it-IT', page: page);

    // If some Italian overviews are missing, take them from the English version
    if (results.any((j) => _isEmpty(j['overview']))) {
      try {
        final english = await _getRaw(path, language: 'en-US', page: page);
        final overviews = {for (final j in english) j['id']: j['overview']};

        for (final j in results) {
          if (_isEmpty(j['overview'])) {
            j['overview'] = overviews[j['id']] ?? '';
          }
        }
      } catch (_) {
        // If the second request fails, keep the Italian lists
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
    final uri = Uri.parse('$_baseUrl/$type/${movie.id}/credits')
        .replace(queryParameters: {'language': 'it-IT'});

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

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final cast = (data['cast'] as List).cast<Map<String, dynamic>>();
    return cast.take(15).map(CastMember.fromJson).toList();
  }
} // <- last brace: closes the TmdbService class