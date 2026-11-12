import 'package:cosmos/services/tmdb_service.dart';

import '../config/api_keys.dart';
import '../models/movie.dart';

import 'package:flutter/foundation.dart';

class MoviesProvider extends ChangeNotifier {
  final TmdbService _service = TmdbService();

  List<Movie> popularMovies = [];
  List<Movie> popularSeries = [];
  List<Movie> upcomingMovies = [];
  List<Movie> onTheAirSeries = [];
  List<Movie> topRatedMovies = [];
  List<Movie> topRatedSeries = [];

  bool isLoading = false;
  String? errorMessage;

  List<Movie> get allPopular => [...popularMovies, ...popularSeries];
  List<Movie> get allUpcoming => [...upcomingMovies, ...onTheAirSeries];
  List<Movie> get allTopRated => [...topRatedMovies, ...topRatedSeries];

  Future<void> loadAll() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getPopularMovies(),
        _service.getPopularSeries(),
        _service.getUpcomingMovies(),
        _service.getOnTheAirSeries(),
        _service.getTopRatedMovies(),
        _service.getTopRatedSeries(),
      ]);
      popularMovies = results[0];
      popularSeries = results[1];
      upcomingMovies = results[2];
      onTheAirSeries = results[3];
      topRatedMovies = results[4];
      topRatedSeries = results[5];
    } catch (e) {
      errorMessage = 'Errore durante il caricamento: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
