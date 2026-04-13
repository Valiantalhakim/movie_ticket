import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../domain/entities/booking.dart';
import '../bloc/booking_bloc.dart';

class BookingSummaryPage extends StatelessWidget {
  const BookingSummaryPage({
    super.key,
    required this.booking,
  });

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final seatLabels =
        booking.seats.map((seat) => '${seat.row}${seat.number}').join(', ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Booking'),
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            context.push(
              '${AppRoutes.paymentPath}?movieTitle=${Uri.encodeComponent(state.booking.movieTitle)}&cinemaName=${Uri.encodeComponent(state.booking.cinemaName ?? '')}&showDate=${Uri.encodeComponent(state.booking.showDate?.toIso8601String() ?? '')}&showTime=${Uri.encodeComponent(state.booking.showTime ?? '')}&seatLabels=${Uri.encodeComponent(state.booking.seats.map((seat) => '${seat.row}${seat.number}').join(','))}&showtimeId=${Uri.encodeComponent(state.booking.showtimeId)}',
              extra: state.booking.totalPrice,
            );
          }
        },
        builder: (context, state) {
          if (state is BookingError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<BookingBloc>().add(
                      CreateBookingEvent(
                        movieTitle: booking.movieTitle,
                        showtimeId: booking.showtimeId,
                        seats: booking.seats,
                        totalPrice: booking.totalPrice,
                      ),
                    );
              },
            );
          }

          final isLoading = state is BookingLoading;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SummaryCard(
                  title: booking.movieTitle,
                  rows: [
                    _SummaryRow(
                      label: 'Cinema',
                      value: booking.cinemaName ?? '-',
                    ),
                    _SummaryRow(
                      label: 'Jadwal',
                      value:
                          '${booking.showDate == null ? '-' : DateFormatter.formatDate(booking.showDate!)} • ${booking.showTime ?? '-'}',
                    ),
                    _SummaryRow(label: 'Kursi', value: seatLabels),
                    _SummaryRow(
                      label: 'Jumlah Kursi',
                      value: '${booking.seats.length} tiket',
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Harga',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.formatIdr(booking.totalPrice),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                CustomButton(
                  label: 'Lanjut ke Pembayaran',
                  isLoading: isLoading,
                  onPressed: isLoading
                      ? null
                      : () {
                          context.read<BookingBloc>().add(
                                CreateBookingEvent(
                                  movieTitle: booking.movieTitle,
                                  showtimeId: booking.showtimeId,
                                  seats: booking.seats,
                                  totalPrice: booking.totalPrice,
                                ),
                              );
                        },
                  icon: Icons.payment_rounded,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.rows,
  });

  final String title;
  final List<_SummaryRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row.label,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      row.value,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

class _SummaryRow {
  const _SummaryRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}
