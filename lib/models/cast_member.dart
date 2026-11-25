class CastMember {
  final String name;
  final String character;
  final String? profilePath;

  const CastMember({
    required this.name,
    required this.character,
    this.profilePath,
  });
  // Full photo URL (TMDB only sends a partial path)
  String? get photoUrl => profilePath == null
      ? null
      : 'https://image.tmdb.org/t/p/w185$profilePath';

  factory CastMember.fromJson(Map<String, dynamic> json) => CastMember(
    name: json['name'] ?? '',
    character: json['character'] ?? '',
    profilePath: json['profile_path'],
  );
}
