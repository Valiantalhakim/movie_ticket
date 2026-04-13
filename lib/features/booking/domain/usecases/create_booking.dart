import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/booking.dart';
import '../entities/seat.dart';
import '../repositories/booking_repository.dart';

class CreateBooking {
  const CreateBooking(this.repository);

  final BookingRepository repository;

  Future<Either<Failure, Booking>> call({
    required String movieTitle,
    required String showtimeId,
    required List<Seat> seats,
    required int totalPrice,
  }) {
    return repository.createBooking(
      movieTitle: movieTitle,
      showtimeId: showtimeId,
      seats: seats,
      totalPrice: totalPrice,
    );
  }
}
