import 'package:flutter/material.dart';
import '../models/seat.dart';
import '../theme/app_theme.dart';

class SeatTile extends StatelessWidget {
  final Seat seat;
  final VoidCallback onTap;

  const SeatTile({super.key, required this.seat, required this.onTap});

  Color _colorFor(SeatStatus status) {
    switch (status) {
      case SeatStatus.available:
        return AppColors.surface;
      case SeatStatus.selected:
        return AppColors.districtRed;
      case SeatStatus.booked:
        return AppColors.line;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBooked = seat.status == SeatStatus.booked;
    return GestureDetector(
      onTap: isBooked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: _colorFor(seat.status),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: seat.status == SeatStatus.selected
                ? AppColors.districtRed
                : AppColors.line,
          ),
          boxShadow: seat.status == SeatStatus.selected
              ? [
                  BoxShadow(
                    color: AppColors.districtRed.withValues(alpha: 0.22),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          seat.label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: isBooked
                ? AppColors.muted.withValues(alpha: 0.6)
                : seat.status == SeatStatus.selected
                ? Colors.white
                : AppColors.carbon,
          ),
        ),
      ),
    );
  }
}
