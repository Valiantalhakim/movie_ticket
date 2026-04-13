import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/seat.dart';
import '../../domain/usecases/get_available_seats.dart';

part 'seat_event.dart';
part 'seat_state.dart';

class SeatBloc extends Bloc<SeatEvent, SeatState> {
  SeatBloc({
    required GetAvailableSeats getAvailableSeats,
  })  : _getAvailableSeats = getAvailableSeats,
        super(const SeatInitial()) {
    on<LoadSeatsEvent>(_onLoadSeats);
    on<SelectSeatEvent>(_onSelectSeat);
    on<DeselectSeatEvent>(_onDeselectSeat);
  }

  final GetAvailableSeats _getAvailableSeats;

  Future<void> _onLoadSeats(
    LoadSeatsEvent event,
    Emitter<SeatState> emit,
  ) async {
    emit(const SeatLoading());

    final result = await _getAvailableSeats(event.showtimeId);
    result.fold(
      (failure) => emit(SeatError(failure.message)),
      (seats) => emit(
        SeatLoaded(
          seats: seats,
          selectedSeats: const <Seat>[],
          totalPrice: 0,
          pricePerSeat: event.pricePerSeat,
        ),
      ),
    );
  }

  void _onSelectSeat(
    SelectSeatEvent event,
    Emitter<SeatState> emit,
  ) {
    final currentState = state;
    if (currentState is! SeatLoaded) {
      return;
    }

    if (event.seat.status == SeatStatus.booked ||
        currentState.selectedSeats.any((seat) => seat.id == event.seat.id)) {
      return;
    }

    final updatedSeats = currentState.seats
        .map(
          (seat) => seat.id == event.seat.id
              ? Seat(
                  id: seat.id,
                  row: seat.row,
                  number: seat.number,
                  status: SeatStatus.selected,
                )
              : seat,
        )
        .toList(growable: false);

    final updatedSelectedSeats = <Seat>[
      ...currentState.selectedSeats,
      Seat(
        id: event.seat.id,
        row: event.seat.row,
        number: event.seat.number,
        status: SeatStatus.selected,
      ),
    ];

    emit(
      currentState.copyWith(
        seats: updatedSeats,
        selectedSeats: updatedSelectedSeats,
        totalPrice: updatedSelectedSeats.length * currentState.pricePerSeat,
      ),
    );
  }

  void _onDeselectSeat(
    DeselectSeatEvent event,
    Emitter<SeatState> emit,
  ) {
    final currentState = state;
    if (currentState is! SeatLoaded) {
      return;
    }

    final updatedSeats = currentState.seats
        .map(
          (seat) => seat.id == event.seat.id
              ? Seat(
                  id: seat.id,
                  row: seat.row,
                  number: seat.number,
                  status: SeatStatus.available,
                )
              : seat,
        )
        .toList(growable: false);

    final updatedSelectedSeats = currentState.selectedSeats
        .where((seat) => seat.id != event.seat.id)
        .toList(growable: false);

    emit(
      currentState.copyWith(
        seats: updatedSeats,
        selectedSeats: updatedSelectedSeats,
        totalPrice: updatedSelectedSeats.length * currentState.pricePerSeat,
      ),
    );
  }
}
