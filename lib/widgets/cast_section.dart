import 'package:flutter/material.dart';

import '../models/cast_member.dart';
import '../models/movie.dart';
import '../screens/actor_screen.dart';
import '../services/tmdb_service.dart';

class CastSection extends StatefulWidget {
  final Movie movie;

  const CastSection({super.key, required this.movie});

  @override
  State<CastSection> createState() => _CastSectionState();
}

class _CastSectionState extends State<CastSection> {
  late final Future<List<CastMember>> _future;

  @override
  void initState() {
    super.initState();
    _future = TmdbService().getCast(widget.movie);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder<List<CastMember>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 160,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // Error or no cast available: hide the section
        final cast = snapshot.data;
        if (snapshot.hasError || cast == null || cast.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cast',
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 170,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: cast.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, i) => _CastCard(member: cast[i]),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Photo, actor name and character: tap to open the actor screen
class _CastCard extends StatelessWidget {
  final CastMember member;

  const _CastCard({required this.member});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final surface = Theme.of(context).colorScheme.surface;

    final placeholder = Container(
      width: 80,
      height: 80,
      color: surface,
      child: const Icon(Icons.person, size: 40),
    );

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ActorScreen(member: member)),
      ),
      child: SizedBox(
        width: 90,
        child: Column(
          children: [
            ClipOval(
              child: member.photoUrl != null
                  ? Image.network(
                      member.photoUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => placeholder,
                    )
                  : placeholder,
            ),
            const SizedBox(height: 8),
            Text(
              member.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (member.character.isNotEmpty)
              Text(
                member.character,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}