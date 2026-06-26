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
      body: Column(
        children: [
          _ShowtimeStrip(movie: widget.movie, showtime: widget.showtime),
          const SizedBox(height: 20),
          const _ScreenIndicator(),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _seatsPerRow,
                          childAspectRatio: 1.04,
                        ),
                    itemCount: _seats.length,
                    itemBuilder: (context, index) {
                      final seat = _seats[index];
                      return SeatTile(
                        seat: seat,
                        onTap: () => _toggleSeat(seat),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const _Legend(),
          const SizedBox(height: 10),
        ],
      ),
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
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.softRed,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.event_seat_rounded,
              color: AppColors.districtRed,
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
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${cinema.name} · ${showtime.time} · ${showtime.screenName}',
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
          const SizedBox(width: 8),
          Text(
            '₹${showtime.pricePerSeat.toStringAsFixed(0)}',
            style: const TextStyle(
              color: AppColors.teal,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScreenIndicator extends StatelessWidget {
  const _ScreenIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 260,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFC2C7), AppColors.districtRed],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.districtRed.withValues(alpha: 0.26),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'SCREEN',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 0,
            color: AppColors.muted,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    Widget item(Color color, String label, {Color? borderColor}) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor ?? AppColors.line),
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
        spacing: 16,
        runSpacing: 8,
        children: [
          item(AppColors.surface, 'Available'),
          item(
            AppColors.districtRed,
            'Selected',
            borderColor: AppColors.districtRed,
          ),
          item(AppColors.line, 'Booked'),
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
    final seatText = hasSelection ? selectedSeats.join(', ') : 'No seats';

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.line)),
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
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '₹${total.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: hasSelection
                        ? AppColors.districtRed
                        : AppColors.muted,
                    fontWeight: FontWeight.w900,
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
