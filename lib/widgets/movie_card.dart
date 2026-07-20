import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../theme/app_theme.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({super.key, required this.movie, required this.onTap});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _hovered ? 1.025 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hovered ? AppColors.gold.withValues(alpha: 0.55) : AppColors.line,
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? AppColors.crimson.withValues(alpha: 0.28)
                    : Colors.black.withValues(alpha: 0.45),
                blurRadius: _hovered ? 28 : 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: GestureDetector(
              onTap: widget.onTap,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'poster-${movie.id}',
                    child: Image.asset(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const _PosterFallback(),
                    ),
                  ),
                  // Bottom gradient so the title stays readable on any poster.
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.45, 0.72, 1.0],
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.35),
                            const Color(0xE60A0C13),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xCC0A0C13),
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: AppColors.glass(0.16)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.gold,
                            size: 14,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            movie.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${movie.genres.take(2).join(' · ')}  ·  ${movie.durationMinutes}m',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.66),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.elevated,
      child: Center(
        child: Icon(
          Icons.local_movies_rounded,
          color: AppColors.muted.withValues(alpha: 0.55),
          size: 42,
        ),
      ),
    );
  }
}
