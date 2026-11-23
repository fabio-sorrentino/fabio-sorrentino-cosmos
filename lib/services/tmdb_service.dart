import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_keys.dart';
import '../models/movie.dart';

//Base URL API
class TmdbService {
  static const _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> _fetch(
    String path, {
    required bool isSeries,
    int page = 1,
  }) async {
    final uri = Uri.parse('$_baseUrl/$path')
        .replace(queryParameters: {'language': 'it-IT', 'page': '$page'});
    final response = await http.get(
      uri,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer ${ApiKeys.tmdbToken}',   //Authorization
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Error TMDB: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List;

    return results
        .map(
          (json) =>
              Movie.fromJson(json as Map<String, dynamic>, isSeries: isSeries),
        )
        .toList();
  }
//Filter Popular, Upcoming and Top Rated
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
}
