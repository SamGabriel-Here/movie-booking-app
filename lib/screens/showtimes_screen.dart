import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/movie.dart';
import '../models/showtime.dart';
import '../theme/app_theme.dart';
import 'seat_selection_screen.dart';

class ShowtimesScreen extends StatelessWidget {
  final Movie movie;

  const ShowtimesScreen({super.key, required this.movie});

  Map<String, List<Showtime>> get _showtimesByCinema {
    final showtimes = showtimesForMovie(movie.id);
    final byCinema = <String, List<Showtime>>{};
    for (final showtime in showtimes) {
      byCinema.putIfAbsent(showtime.cinemaId, () => []).add(showtime);
    }
    return byCinema;
  }

  String _dateLabel(String rawDate) {
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final showDate = DateTime(parsed.year, parsed.month, parsed.day);

    if (showDate == today) return 'Today, $rawDate';
    if (showDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow, $rawDate';
    }
    return rawDate;
  }

  void _openSeats(BuildContext context, Showtime showtime) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SeatSelectionScreen(movie: movie, showtime: showtime),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final byCinema = _showtimesByCinema;
    final date = byCinema.values.first.first.date;

    return Scaffold(
      appBar: AppBar(title: const Text('Select showtime')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _MovieSummary(movie: movie),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 18,
                color: AppColors.districtRed,
              ),
              const SizedBox(width: 8),
              Text(
                _dateLabel(date),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final entry in byCinema.entries) ...[
            _CinemaShowtimesCard(
              cinemaId: entry.key,
              showtimes: entry.value,
              onSelect: (showtime) => _openSeats(context, showtime),
            ),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _MovieSummary extends StatelessWidget {
  final Movie movie;

  const _MovieSummary({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              movie.posterUrl,
              width: 58,
              height: 78,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 58,
                height: 78,
                color: AppColors.softRed,
                child: const Icon(
                  Icons.local_movies_rounded,
                  color: AppColors.districtRed,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${movie.durationMinutes} min · ${movie.genres.take(2).join(' / ')}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CinemaShowtimesCard extends StatelessWidget {
  final String cinemaId;
  final List<Showtime> showtimes;
  final ValueChanged<Showtime> onSelect;

  const _CinemaShowtimesCard({
    required this.cinemaId,
    required this.showtimes,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final cinema = cinemaById(cinemaId);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.softRed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.theaters_rounded,
                    color: AppColors.districtRed,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cinema.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        cinema.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: showtimes
                  .map(
                    (showtime) => OutlinedButton(
                      onPressed: () => onSelect(showtime),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(showtime.time),
                          Text(
                            '₹${showtime.pricePerSeat.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: AppColors.teal,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
