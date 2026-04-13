import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/booking.dart';
import '../../domain/entities/seat.dart';
import '../../domain/usecases/create_booking.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc({
    required CreateBooking createBooking,
  })  : _createBooking = createBooking,
        super(const BookingInitial()) {
    on<CreateBookingEvent>(_onCreateBooking);
    on<ResetBookingEvent>(_onResetBooking);
  }

  final CreateBooking _createBooking;

  Future<void> _onCreateBooking(
    CreateBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());

    final result = await _createBooking(
      movieTitle: event.movieTitle,
      showtimeId: event.showtimeId,
      seats: event.seats,
      totalPrice: event.totalPrice,
    );

    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (booking) => emit(BookingSuccess(booking)),
    );
  }

  void _onResetBooking(
    ResetBookingEvent event,
    Emitter<BookingState> emit,
  ) {
    emit(const BookingInitial());
  }
}
