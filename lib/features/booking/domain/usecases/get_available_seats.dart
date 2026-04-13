import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/seat.dart';
import '../repositories/booking_repository.dart';

class GetAvailableSeats {
  const GetAvailableSeats(this.repository);

  final BookingRepository repository;

  Future<Either<Failure, List<Seat>>> call(String showtimeId) {
    return repository.getSeats(showtimeId);
  }
}
