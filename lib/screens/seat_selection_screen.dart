import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/movie.dart';
import '../models/seat.dart';
import '../models/showtime.dart';
import '../theme/app_theme.dart';
import '../widgets/seat_tile.dart';
import 'checkout_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Movie movie;
  final Showtime showtime;

  const SeatSelectionScreen({
    super.key,
    required this.movie,
    required this.showtime,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  static const _rows = ['A', 'B', 'C', 'D', 'E', 'F'];
  static const _seatsPerRow = 8;
  static const _bookedLabels = {'A3', 'A4', 'C5', 'D1', 'D2', 'F8'};

  late final List<Seat> _seats = [
    for (final row in _rows)
      for (var n = 1; n <= _seatsPerRow; n++)
        Seat(
          row: row,
          number: n,
          status: _bookedLabels.contains('$row$n')
              ? SeatStatus.booked
              : SeatStatus.available,
        ),
  ];

  List<Seat> get _selectedSeats =>
      _seats.where((s) => s.status == SeatStatus.selected).toList();

  double get _total => _selectedSeats.length * widget.showtime.pricePerSeat;

  void _toggleSeat(Seat seat) {
    if (seat.status == SeatStatus.booked) return;

    setState(() {
      seat.status = seat.status == SeatStatus.selected
          ? SeatStatus.available
          : SeatStatus.selected;
    });
  }

  void _openCheckout() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(
          movie: widget.movie,
          showtime: widget.showtime,
          selectedSeats: _selectedSeats.map((s) => s.label).toList(),
          total: _total,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedSeats = _selectedSeats;

    return Scaffold(
      appBar: AppBar(title: const Text('Choose seats')),
      bottomNavigationBar: _SeatSummaryBar(
        selectedSeats: selectedSeats.map((seat) => seat.label).toList(),
        total: _total,
        onContinue: selectedSeats.isEmpty ? null : _openCheckout,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ShowtimeStrip(movie: widget.movie, showtime: widget.showtime),
            const SizedBox(height: 26),
            const _ScreenIndicator(),
            const SizedBox(height: 26),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Row label columns + centre aisle + per-seat margins.
                      final seatSize =
                          ((constraints.maxWidth - 2 * 22 - 26) / _seatsPerRow -
                                  6)
                              .clamp(24.0, 44.0);

                      return Column(
                        children: [
                          for (var r = 0; r < _rows.length; r++) ...[
                            _SeatRow(
                              rowLabel: _rows[r],
                              seats: _seats.sublist(
                                r * _seatsPerRow,
                                (r + 1) * _seatsPerRow,
                              ),
                              seatSize: seatSize,
                              onToggle: _toggleSeat,
                            ),
                            const SizedBox(height: 2),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const _Legend(),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class _SeatRow extends StatelessWidget {
  final String rowLabel;
  final List<Seat> seats;
  final double seatSize;
  final ValueChanged<Seat> onToggle;

  const _SeatRow({
    required this.rowLabel,
    required this.seats,
    required this.seatSize,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final half = seats.length ~/ 2;

    Widget label() => SizedBox(
      width: 22,
      child: Text(
        rowLabel,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.muted.withValues(alpha: 0.65),
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        label(),
        for (final seat in seats.take(half))
          SeatTile(
            seat: seat,
            size: seatSize,
            onTap: () => onToggle(seat),
          ),
        const SizedBox(width: 26),
        for (final seat in seats.skip(half))
          SeatTile(
            seat: seat,
            size: seatSize,
            onTap: () => onToggle(seat),
          ),
        label(),
      ],
    );
  }
}

class _ScreenIndicator extends StatelessWidget {
  const _ScreenIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Perspective-tilted glowing screen.
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateX(-0.6),
          child: Container(
            width: 300,
            height: 26,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.gold.withValues(alpha: 0.95),
                  AppColors.goldDeep.withValues(alpha: 0.35),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.35),
                  blurRadius: 40,
                  spreadRadius: 4,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'S C R E E N',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 3,
            color: AppColors.muted.withValues(alpha: 0.8),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ShowtimeStrip extends StatelessWidget {
  final Movie movie;
  final Showtime showtime;

  const _ShowtimeStrip({required this.movie, required this.showtime});

  @override
  Widget build(BuildContext context) {
    final cinema = cinemaById(showtime.cinemaId);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.crimson.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.event_seat_rounded,
              color: AppColors.crimson,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${cinema.name} · ${showtime.time} · ${showtime.screenName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '₹${showtime.pricePerSeat.toStringAsFixed(0)}',
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    Widget item({
      Color? color,
      Gradient? gradient,
      Color? borderColor,
      required String label,
    }) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: color,
            gradient: gradient,
            borderRadius: BorderRadius.circular(5),
            border: borderColor != null ? Border.all(color: borderColor) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.muted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 18,
        runSpacing: 8,
        children: [
          item(
            color: AppColors.glass(0.07),
            borderColor: AppColors.glass(0.2),
            label: 'Available',
          ),
          item(gradient: AppColors.goldGradient, label: 'Selected'),
          item(
            color: AppColors.glass(0.04),
            borderColor: AppColors.glass(0.06),
            label: 'Booked',
          ),
        ],
      ),
    );
  }
}

class _SeatSummaryBar extends StatelessWidget {
  final List<String> selectedSeats;
  final double total;
  final VoidCallback? onContinue;

  const _SeatSummaryBar({
    required this.selectedSeats,
    required this.total,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedSeats.isNotEmpty;
    final seatText = hasSelection ? selectedSeats.join(', ') : 'No seats selected';

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.glass(0.08))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    seatText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: hasSelection ? AppColors.text : AppColors.muted,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '₹${total.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: hasSelection ? AppColors.gold : AppColors.muted,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: onContinue,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(
                hasSelection
                    ? 'Continue with ${selectedSeats.length} seat${selectedSeats.length == 1 ? '' : 's'}'
                    : 'Select seats to continue',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
