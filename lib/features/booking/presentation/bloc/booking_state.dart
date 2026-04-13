part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => <Object?>[];
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingLoading extends BookingState {
  const BookingLoading();
}

class BookingSuccess extends BookingState {
  const BookingSuccess(this.booking);

  final Booking booking;

  @override
  List<Object?> get props => <Object?>[booking.id, booking.status];
}

class BookingError extends BookingState {
  const BookingError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
