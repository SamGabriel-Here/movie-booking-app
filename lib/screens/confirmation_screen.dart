import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/movie.dart';
import '../models/showtime.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class ConfirmationScreen extends StatelessWidget {
  final Movie movie;
  final Showtime showtime;
  final List<String> selectedSeats;
  final double total;

  const ConfirmationScreen({
    super.key,
    required this.movie,
    required this.showtime,
    required this.selectedSeats,
    required this.total,
  });

  String get _bookingId {
    final seed = '${movie.id}${showtime.id}${selectedSeats.join()}'.hashCode;
    final value = seed.abs().toString().padLeft(8, '0').substring(0, 8);
    return 'BK-$value';
  }

  void _backHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cinema = cinemaById(showtime.cinemaId);

    return Scaffold(
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: OutlinedButton.icon(
            onPressed: () => _backHome(context),
            icon: const Icon(Icons.home_rounded),
            label: const Text('Back to home'),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
          children: [
            const CircleAvatar(
              radius: 38,
              backgroundColor: Color(0xFFE5F8EF),
              child: Icon(
                Icons.check_rounded,
                color: AppColors.success,
                size: 46,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Booking confirmed',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              _bookingId,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.muted,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),
            _TicketCard(
              movie: movie,
              cinemaName: cinema.name,
              showtime: showtime,
              selectedSeats: selectedSeats,
              total: total,
              bookingId: _bookingId,
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final Movie movie;
  final String cinemaName;
  final Showtime showtime;
  final List<String> selectedSeats;
  final double total;
  final String bookingId;

  const _TicketCard({
    required this.movie,
    required this.cinemaName,
    required this.showtime,
    required this.selectedSeats,
    required this.total,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.softRed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Paid',
                    style: TextStyle(
                      color: AppColors.districtRed,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _DetailRow(
              icon: Icons.theaters_rounded,
              label: 'Cinema',
              value: cinemaName,
            ),
            const SizedBox(height: 14),
            _DetailRow(
              icon: Icons.schedule_rounded,
              label: 'Showtime',
              value: '${showtime.date} · ${showtime.time}',
            ),
            const SizedBox(height: 14),
            _DetailRow(
              icon: Icons.event_seat_rounded,
              label: 'Seats',
              value: selectedSeats.join(', '),
            ),
            const SizedBox(height: 18),
            const Divider(),
            const SizedBox(height: 18),
            Center(
              child: Container(
                width: 164,
                height: 164,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.line),
                ),
                child: const Icon(
                  Icons.qr_code_2_rounded,
                  size: 132,
                  color: AppColors.ink,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: Text(
                bookingId,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.canvas,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total paid',
                    style: TextStyle(
                      color: AppColors.carbon,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '₹${total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppColors.districtRed,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
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
                label,
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
