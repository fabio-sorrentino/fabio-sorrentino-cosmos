class CastMember {
  final int id;
  final String name;
  final String character;
  final String? profilePath;

  const CastMember({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
  });

  String? get photoUrl => profilePath == null
      ? null
      : 'https://image.tmdb.org/t/p/w185$profilePath';

  factory CastMember.fromJson(Map<String, dynamic> json) => CastMember(
        id: json['id'],
        name: json['name'] ?? '',
        character: json['character'] ?? '',
        profilePath: json['profile_path'],
      );
}