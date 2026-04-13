part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class CreateBookingEvent extends BookingEvent {
  const CreateBookingEvent({
    required this.movieTitle,
    required this.showtimeId,
    required this.seats,
    required this.totalPrice,
  });

  final String movieTitle;
  final String showtimeId;
  final List<Seat> seats;
  final int totalPrice;

  @override
  List<Object?> get props => <Object?>[
        movieTitle,
        showtimeId,
        seats.map((seat) => seat.id).toList(),
        totalPrice,
      ];
}

class ResetBookingEvent extends BookingEvent {
  const ResetBookingEvent();
}
