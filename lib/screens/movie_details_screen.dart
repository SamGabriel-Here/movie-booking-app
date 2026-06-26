import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../theme/app_theme.dart';
import 'showtimes_screen.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  void _openShowtimes(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ShowtimesScreen(movie: movie)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          child: FilledButton.icon(
            onPressed: () => _openShowtimes(context),
            icon: const Icon(Icons.confirmation_number_rounded),
            label: const Text('Book tickets'),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.ink,
            foregroundColor: Colors.white,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
            title: Text(movie.title),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'poster-${movie.id}',
                    child: Image.asset(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const _DetailsPosterFallback(),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.05),
                          Colors.black.withValues(alpha: 0.38),
                          AppColors.ink.withValues(alpha: 0.94),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            height: 1.04,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _HeroPill(
                              icon: Icons.star_rounded,
                              label: movie.rating.toStringAsFixed(1),
                              color: AppColors.gold,
                            ),
                            _HeroPill(
                              icon: Icons.schedule_rounded,
                              label: '${movie.durationMinutes} min',
                              color: Colors.white,
                            ),
                            _HeroPill(
                              icon: Icons.theaters_rounded,
                              label: movie.genres.first,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: movie.genres
                        .map((genre) => Chip(label: Text(genre)))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Synopsis',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    movie.synopsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.carbon,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 18),
                  _InfoRow(
                    icon: Icons.location_on_rounded,
                    title: 'City',
                    value: 'Bengaluru',
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    icon: Icons.local_activity_rounded,
                    title: 'Format',
                    value: '2D, mobile ticket accepted',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _HeroPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.softRed,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.districtRed, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailsPosterFallback extends StatelessWidget {
  const _DetailsPosterFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.softRed,
      child: Center(
        child: Icon(
          Icons.local_movies_rounded,
          color: AppColors.districtRed,
          size: 64,
        ),
      ),
    );
  }
}
