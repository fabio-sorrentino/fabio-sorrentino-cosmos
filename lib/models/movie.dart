class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final bool isSeries;
  final double voteAverage;
  final String? releaseDate;
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'overview': overview,
    'vote_average': voteAverage,
    'release_date': releaseDate,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'is_series': isSeries,
  };

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.isSeries,
    this.posterPath,
    this.backdropPath,
    this.voteAverage = 0,
    this.releaseDate,
  });

  String? get posterUrl =>
      posterPath == null ? null : 'https://image.tmdb.org/t/p/w342$posterPath';

  String? get backdropUrl => backdropPath == null
      ? null
      : 'https://image.tmdb.org/t/p/w780$backdropPath';

  factory Movie.fromJson(Map<String, dynamic> json, {required bool isSeries}) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? json['name'] ?? '',
      overview: json['overview'] ?? '',
      isSeries: isSeries,
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? json['first_air_date'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'], // nuovo
    );
  }
}
