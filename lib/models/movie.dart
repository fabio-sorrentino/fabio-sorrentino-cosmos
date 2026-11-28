class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final bool isSeries;
  final double voteAverage;
  final String? releaseDate;

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

  // Full poster URL (TMDB only sends a partial path)
  String? get posterUrl => posterPath == null
      ? null
      : 'https://image.tmdb.org/t/p/w342$posterPath';

  // Full backdrop URL (wide image)
  String? get backdropUrl => backdropPath == null
      ? null
      : 'https://image.tmdb.org/t/p/w780$backdropPath';

  // Converts a TMDB response into a Movie
  factory Movie.fromJson(Map<String, dynamic> json, {required bool isSeries}) {
    return Movie(
      id: json['id'],
      // movies have "title", series have "name"
      title: json['title'] ?? json['name'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      isSeries: isSeries,
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      // movies have "release_date", series have "first_air_date"
      releaseDate: json['release_date'] ?? json['first_air_date'],
    );
  }

  // Converts the movie into savable data
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'overview': overview,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        'vote_average': voteAverage,
        'release_date': releaseDate,
        'is_series': isSeries,
      };

  // Rebuilds the movie from saved data
  factory Movie.fromStoredJson(Map<String, dynamic> json) =>
      Movie.fromJson(json, isSeries: json['is_series'] == true);
}