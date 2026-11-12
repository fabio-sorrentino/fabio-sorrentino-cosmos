class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final bool isSeries;
  final double voteAverage;
  final String? releaseDate;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.isSeries,
    this.posterPath,
    this.voteAverage = 0,
    this.releaseDate,
  });

  String? get posterUrl =>
      posterPath == null ? null : 'https://image.tmdb.org/t/p/w342$posterPath';

  factory Movie.fromJson(
    Map<String, dynamic> json, {
      required bool isSeries,}) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? json['name'] ?? '',
      overview: json['overview'] ?? '',
      isSeries: isSeries,
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? json['first_air_date'],
      posterPath: json['poster_path'],
    );
  }
}
