import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/seat.dart';

class SeatWidget extends StatelessWidget {
  const SeatWidget({
    super.key,
    required this.seat,
    required this.onTap,
  });

  final Seat seat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = switch (seat.status) {
      SeatStatus.available => Colors.grey.shade500,
      SeatStatus.selected => Colors.blue.shade500,
      SeatStatus.booked => AppColors.error,
    };

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.96, end: 1),
      duration: const Duration(milliseconds: 180),
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: seat.status == SeatStatus.booked ? null : onTap,
          child: Ink(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.textPrimary.withOpacity(0.16),
              ),
            ),
            child: Center(
              child: Text(
                '${seat.row}${seat.number}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
