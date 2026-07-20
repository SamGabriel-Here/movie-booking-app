import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/movie.dart';
import '../models/showtime.dart';
import '../theme/app_theme.dart';
import 'confirmation_screen.dart';

class CheckoutScreen extends StatelessWidget {
  final Movie movie;
  final Showtime showtime;
  final List<String> selectedSeats;
  final double total;

  const CheckoutScreen({
    super.key,
    required this.movie,
    required this.showtime,
    required this.selectedSeats,
    required this.total,
  });

  void _confirmBooking(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ConfirmationScreen(
          movie: movie,
          showtime: showtime,
          selectedSeats: selectedSeats,
          total: total,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cinema = cinemaById(showtime.cinemaId);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.glass(0.08))),
          ),
          child: FilledButton.icon(
            onPressed: () => _confirmBooking(context),
            icon: const Icon(Icons.lock_rounded),
            label: Text('Pay ₹${total.toStringAsFixed(0)}'),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _TicketPreview(
            movie: movie,
            cinemaName: cinema.name,
            cinemaLocation: cinema.location,
            showtime: showtime,
            selectedSeats: selectedSeats,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                _SummaryRow(
                  label: 'Tickets (${selectedSeats.length})',
                  value:
                      '₹${(showtime.pricePerSeat * selectedSeats.length).toStringAsFixed(0)}',
                ),
                const SizedBox(height: 12),
                _SummaryRow(
                  label: 'Price per seat',
                  value: '₹${showtime.pricePerSeat.toStringAsFixed(0)}',
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                _SummaryRow(
                  label: 'Total',
                  value: '₹${total.toStringAsFixed(0)}',
                  isTotal: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketPreview extends StatelessWidget {
  final Movie movie;
  final String cinemaName;
  final String cinemaLocation;
  final Showtime showtime;
  final List<String> selectedSeats;

  const _TicketPreview({
    required this.movie,
    required this.cinemaName,
    required this.cinemaLocation,
    required this.showtime,
    required this.selectedSeats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.elevated,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glass(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    movie.posterUrl,
                    width: 70,
                    height: 96,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 70,
                      height: 96,
                      color: AppColors.surface,
                      child: const Icon(
                        Icons.local_movies_rounded,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.text,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _TicketLine(
                        icon: Icons.location_on_rounded,
                        text: '$cinemaName · $cinemaLocation',
                      ),
                      const SizedBox(height: 6),
                      _TicketLine(
                        icon: Icons.schedule_rounded,
                        text:
                            '${showtime.date} · ${showtime.time} · ${showtime.screenName}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const TicketPerforation(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SEATS',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selectedSeats.join(', '),
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.qr_code_2_rounded,
                  size: 44,
                  color: AppColors.muted.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dashed line with semicircular notches, like a torn cinema ticket edge.
class TicketPerforation extends StatelessWidget {
  final Color notchColor;

  const TicketPerforation({super.key, this.notchColor = AppColors.night});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: CustomPaint(painter: _DashPainter()),
            ),
          ),
          Positioned(
            left: -12,
            top: 0,
            child: _notch(),
          ),
          Positioned(
            right: -12,
            top: 0,
            child: _notch(),
          ),
        ],
      ),
    );
  }

  Widget _notch() => Container(
    width: 24,
    height: 24,
    decoration: BoxDecoration(color: notchColor, shape: BoxShape.circle),
  );
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.glass(0.18)
      ..strokeWidth = 1.4;

    const dashWidth = 6.0;
    const gap = 5.0;
    final y = size.height / 2;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
      x += dashWidth + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TicketLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TicketLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.gold, size: 15),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = isTotal
        ? Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w800,
          )
        : const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w600);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: labelStyle)),
        const SizedBox(width: 12),
        Text(
          value,
          style: isTotal
              ? Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w800,
                )
              : const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w700,
                ),
        ),
      ],
    );
  }
}
