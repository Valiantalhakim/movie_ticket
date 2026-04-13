part of 'seat_bloc.dart';

abstract class SeatEvent extends Equatable {
  const SeatEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoadSeatsEvent extends SeatEvent {
  const LoadSeatsEvent(this.showtimeId, this.pricePerSeat);

  final String showtimeId;
  final int pricePerSeat;

  @override
  List<Object?> get props => <Object?>[showtimeId, pricePerSeat];
}

class SelectSeatEvent extends SeatEvent {
  const SelectSeatEvent(this.seat);

  final Seat seat;

  @override
  List<Object?> get props => <Object?>[seat.id, seat.row, seat.number, seat.status];
}

class DeselectSeatEvent extends SeatEvent {
  const DeselectSeatEvent(this.seat);

  final Seat seat;

  @override
  List<Object?> get props => <Object?>[seat.id, seat.row, seat.number, seat.status];
}
