import 'package:flutter/material.dart';

import '../models/cast_member.dart';
import '../models/movie.dart';
import '../models/person.dart';
import '../services/tmdb_service.dart';
import '../widgets/movie_poster.dart';
import 'detail_screen.dart';

class ActorScreen extends StatefulWidget {
  final CastMember member;

  const ActorScreen({super.key, required this.member});

  @override
  State<ActorScreen> createState() => _ActorScreenState();
}

class _ActorScreenState extends State<ActorScreen> {
  late final Future<Person> _person;
  late final Future<List<Movie>> _movies;

  @override
  void initState() {
    super.initState();
    final service = TmdbService();
    _person = service.getPerson(widget.member.id);
    _movies = service.getPersonCredits(widget.member.id);
  }

  @override
  Widget build(BuildContext context) {
    final member = widget.member;
    final textTheme = Theme.of(context).textTheme;
    final surface = Theme.of(context).colorScheme.surface;

    final photoPlaceholder = Container(
      width: 140,
      height: 140,
      color: surface,
      child: const Icon(Icons.person, size: 70),
    );

    return Scaffold(
      appBar: AppBar(scrolledUnderElevation: 0, title: const Text('Attore')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          // Photo and name (already available from the cast)
          Center(
            child: ClipOval(
              child: member.photoUrl != null
                  ? Image.network(
                      member.photoUrl!,
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => photoPlaceholder,
                    )
                  : photoPlaceholder,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            member.name,
            textAlign: TextAlign.center,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          // Birth data and biography
          FutureBuilder<Person>(
            future: _person,
            builder: (context, snapshot) {
              final person = snapshot.data;
              if (person == null) return const SizedBox.shrink();

              final birth = [
                if (person.birthday != null && person.birthday!.isNotEmpty)
                  person.birthday!.split('-').reversed.join('/'),
                if (person.placeOfBirth != null &&
                    person.placeOfBirth!.isNotEmpty)
                  person.placeOfBirth!,
              ].join(' · ');

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (birth.isNotEmpty)
                    Text(
                      birth,
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall,
                    ),
                  const SizedBox(height: 16),
                  Text(
                    person.biography.isEmpty
                        ? 'Biografia non disponibile'
                        : person.biography,
                    style: textTheme.bodyMedium,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // Movies and series of the actor
          FutureBuilder<List<Movie>>(
            future: _movies,
            builder: (context, snapshot) {
              final movies = snapshot.data;
              if (movies == null || movies.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Film e serie TV',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: movies.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, i) => SizedBox(
                        width: 120,
                        child: MoviePoster(
                          movie: movies[i],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(movie: movies[i]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}