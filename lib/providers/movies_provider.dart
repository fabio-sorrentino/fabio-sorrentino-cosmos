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
}