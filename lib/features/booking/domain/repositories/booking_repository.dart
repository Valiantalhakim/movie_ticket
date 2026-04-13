import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/booking.dart';
import '../entities/seat.dart';

abstract class BookingRepository {
  Future<Either<Failure, List<Seat>>> getSeats(String showtimeId);
  Future<Either<Failure, Booking>> createBooking({
    required String movieTitle,
    required String showtimeId,
    required List<Seat> seats,
    required int totalPrice,
  });
}
