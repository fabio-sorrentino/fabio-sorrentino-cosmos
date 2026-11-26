class Person {
  final String name;
  final String biography;
  final String? birthday;
  final String? placeOfBirth;

  const Person({
    required this.name,
    required this.biography,
    this.birthday,
    this.placeOfBirth,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        name: json['name'] ?? '',
        biography: json['biography'] ?? '',
        birthday: json['birthday'],
        placeOfBirth: json['place_of_birth'],
      );
}