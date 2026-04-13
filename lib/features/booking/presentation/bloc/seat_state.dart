part of 'seat_bloc.dart';

abstract class SeatState extends Equatable {
  const SeatState();

  @override
  List<Object?> get props => <Object?>[];
}

class SeatInitial extends SeatState {
  const SeatInitial();
}

class SeatLoading extends SeatState {
  const SeatLoading();
}

class SeatLoaded extends SeatState {
  const SeatLoaded({
    required this.seats,
    required this.selectedSeats,
    required this.totalPrice,
    required this.pricePerSeat,
  });

  final List<Seat> seats;
  final List<Seat> selectedSeats;
  final int totalPrice;
  final int pricePerSeat;

  SeatLoaded copyWith({
    List<Seat>? seats,
    List<Seat>? selectedSeats,
    int? totalPrice,
    int? pricePerSeat,
  }) {
    return SeatLoaded(
      seats: seats ?? this.seats,
      selectedSeats: selectedSeats ?? this.selectedSeats,
      totalPrice: totalPrice ?? this.totalPrice,
      pricePerSeat: pricePerSeat ?? this.pricePerSeat,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        seats.map((seat) => '${seat.id}-${seat.status.name}').toList(),
        selectedSeats.map((seat) => seat.id).toList(),
        totalPrice,
        pricePerSeat,
      ];
}

class SeatError extends SeatState {
  const SeatError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
