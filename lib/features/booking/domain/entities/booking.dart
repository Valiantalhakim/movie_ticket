import 'seat.dart';

class Booking {
  const Booking({
    required this.id,
    required this.movieTitle,
    required this.showtimeId,
    required this.seats,
    required this.totalPrice,
    required this.status,
    this.cinemaName,
    this.showDate,
    this.showTime,
    this.paymentMethod,
  });

  final String id;
  final String movieTitle;
  final String showtimeId;
  final List<Seat> seats;
  final int totalPrice;
  final String status;
  final String? cinemaName;
  final DateTime? showDate;
  final String? showTime;
  final String? paymentMethod;
}
