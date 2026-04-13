import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/seat.dart';
import '../bloc/seat_bloc.dart';
import '../widgets/seat_legend.dart';
import '../widgets/seat_widget.dart';

class SeatSelectionPage extends StatefulWidget {
  const SeatSelectionPage({
    super.key,
    required this.movieTitle,
    required this.showtimeId,
    required this.cinemaName,
    required this.showDate,
    required this.showTime,
    required this.pricePerSeat,
  });

  final String movieTitle;
  final String showtimeId;
  final String cinemaName;
  final DateTime showDate;
  final String showTime;
  final int pricePerSeat;

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<SeatBloc>()
        .add(LoadSeatsEvent(widget.showtimeId, widget.pricePerSeat));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Kursi'),
      ),
      body: BlocBuilder<SeatBloc, SeatState>(
        builder: (context, state) {
          if (state is SeatLoading || state is SeatInitial) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: LoadingWidget(height: 420, borderRadius: 24),
            );
          }

          if (state is SeatError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () {
                context
                    .read<SeatBloc>()
                    .add(LoadSeatsEvent(widget.showtimeId, widget.pricePerSeat));
              },
            );
          }

          final loadedState = state as SeatLoaded;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.movieTitle,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${widget.cinemaName} • ${DateFormatter.formatDate(widget.showDate)} • ${widget.showTime}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Harga per kursi: ${CurrencyFormatter.formatIdr(widget.pricePerSeat)}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Center(
                  child: Text(
                    'LAYAR',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 36),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 20),
                const SeatLegend(),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: loadedState.seats.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final seat = loadedState.seats[index];
                      return SeatWidget(
                        seat: seat,
                        onTap: () {
                          if (seat.status == SeatStatus.selected) {
                            context
                                .read<SeatBloc>()
                                .add(DeselectSeatEvent(seat));
                          } else if (seat.status == SeatStatus.available) {
                            context.read<SeatBloc>().add(SelectSeatEvent(seat));
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loadedState.selectedSeats.isEmpty
                            ? 'Belum ada kursi dipilih'
                            : 'Kursi dipilih: ${_seatLabels(loadedState.selectedSeats)}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Total: ${CurrencyFormatter.formatIdr(loadedState.totalPrice)}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        label: 'Lanjutkan',
                        onPressed: loadedState.selectedSeats.isEmpty
                            ? null
                            : () {
                                context.push(
                                  AppRoutes.summaryPath,
                                  extra: Booking(
                                    id:
                                        'draft_${DateTime.now().microsecondsSinceEpoch}',
                                    movieTitle: widget.movieTitle,
                                    showtimeId: widget.showtimeId,
                                    seats: loadedState.selectedSeats,
                                    totalPrice: loadedState.totalPrice,
                                    status: 'draft',
                                    cinemaName: widget.cinemaName,
                                    showDate: widget.showDate,
                                    showTime: widget.showTime,
                                  ),
                                );
                              },
                        icon: Icons.arrow_forward_rounded,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _seatLabels(List<Seat> seats) {
    return seats.map((seat) => '${seat.row}${seat.number}').join(', ');
  }
}
