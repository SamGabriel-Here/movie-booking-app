import 'package:flutter/material.dart';
import '../models/seat.dart';
import '../theme/app_theme.dart';

class SeatTile extends StatelessWidget {
  final Seat seat;
  final double size;
  final VoidCallback onTap;

  const SeatTile({
    super.key,
    required this.seat,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isBooked = seat.status == SeatStatus.booked;
    final isSelected = seat.status == SeatStatus.selected;

    return MouseRegion(
      cursor: isBooked ? MouseCursor.defer : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isBooked ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          width: size,
          height: size,
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.goldGradient : null,
            color: isSelected
                ? null
                : isBooked
                ? AppColors.glass(0.04)
                : AppColors.glass(0.07),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(size * 0.32),
              bottom: Radius.circular(size * 0.16),
            ),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : isBooked
                  ? AppColors.glass(0.06)
                  : AppColors.glass(0.2),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.45),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: isBooked
              ? Icon(
                  Icons.close_rounded,
                  size: size * 0.42,
                  color: AppColors.muted.withValues(alpha: 0.4),
                )
              : Text(
                  '${seat.number}',
                  style: TextStyle(
                    fontSize: size * 0.32,
                    fontWeight: FontWeight.w800,
                    color: isSelected
                        ? const Color(0xFF201502)
                        : AppColors.muted,
                  ),
                ),
        ),
      ),
    );
  }
}
