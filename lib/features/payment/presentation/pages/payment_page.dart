import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../booking/domain/entities/booking.dart';
import '../../../booking/domain/entities/seat.dart';
import '../bloc/payment_bloc.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({
    super.key,
    required this.totalPrice,
    required this.movieTitle,
    required this.cinemaName,
    required this.showDate,
    required this.showTime,
    required this.showtimeId,
    required this.seatLabels,
  });

  final int totalPrice;
  final String movieTitle;
  final String cinemaName;
  final DateTime showDate;
  final String showTime;
  final String showtimeId;
  final List<String> seatLabels;

  @override
  Widget build(BuildContext context) {
    return _PaymentView(
      movieTitle: movieTitle,
      cinemaName: cinemaName,
      showDate: showDate,
      showTime: showTime,
      showtimeId: showtimeId,
      seatLabels: seatLabels,
      totalPrice: totalPrice,
    );
  }
}

class _PaymentView extends StatelessWidget {
  const _PaymentView({
    required this.movieTitle,
    required this.cinemaName,
    required this.showDate,
    required this.showTime,
    required this.showtimeId,
    required this.seatLabels,
    required this.totalPrice,
  });

  final String movieTitle;
  final String cinemaName;
  final DateTime showDate;
  final String showTime;
  final String showtimeId;
  final List<String> seatLabels;
  final int totalPrice;

  static const List<_PaymentMethodOption> _methods = <_PaymentMethodOption>[
    _PaymentMethodOption(
      label: 'Kartu Kredit',
      icon: Icons.credit_card_rounded,
    ),
    _PaymentMethodOption(
      label: 'E-Wallet',
      icon: Icons.account_balance_wallet_rounded,
    ),
    _PaymentMethodOption(
      label: 'Transfer Bank',
      icon: Icons.account_balance_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listenWhen: (previous, current) => current is PaymentSuccess,
      listener: (context, state) {
        final successState = state as PaymentSuccess;
        context.go(
          AppRoutes.ticketPath,
          extra: Booking(
            id: 'ticket_${DateTime.now().microsecondsSinceEpoch}',
            movieTitle: movieTitle,
            showtimeId: showtimeId,
            seats: seatLabels
                .map(
                  (label) => Seat(
                    id: '$showtimeId-$label',
                    row: label.substring(0, 1),
                    number: int.parse(label.substring(1)),
                    status: SeatStatus.booked,
                  ),
                )
                .toList(growable: false),
            totalPrice: totalPrice,
            status: 'paid',
            cinemaName: cinemaName,
            showDate: showDate,
            showTime: showTime,
            paymentMethod: successState.selectedMethod,
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pembayaran'),
        ),
        body: BlocBuilder<PaymentBloc, PaymentState>(
          builder: (context, state) {
            final selectedMethod = state.selectedMethod;
            final isLoading = state is PaymentLoading;

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                        const Text(
                          'Total Pembayaran',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          CurrencyFormatter.formatIdr(totalPrice),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Pilih Metode Pembayaran',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ..._methods.map(
                    (method) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _PaymentMethodCard(
                        option: method,
                        isSelected: selectedMethod == method.label,
                        onTap: () {
                          context.read<PaymentBloc>().add(
                                SelectPaymentMethodEvent(method.label),
                              );
                        },
                      ),
                    ),
                  ),
                  if (state is PaymentError) ...[
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const Spacer(),
                  CustomButton(
                    label: 'Konfirmasi Pembayaran',
                    isLoading: isLoading,
                    onPressed: selectedMethod == null || isLoading
                        ? null
                        : () {
                            context.read<PaymentBloc>().add(
                                  ConfirmPaymentEvent(selectedMethod),
                                );
                          },
                    icon: Icons.lock_rounded,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final _PaymentMethodOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surfaceAlt : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  option.icon,
                  color: AppColors.primaryLight,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  option.label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: isSelected
                    ? AppColors.primaryLight
                    : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodOption {
  const _PaymentMethodOption({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}
