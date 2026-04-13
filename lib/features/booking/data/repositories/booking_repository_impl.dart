import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/seat.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_local_datasource.dart';
import '../models/seat_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl({
    required this.localDataSource,
  });

  final BookingLocalDataSource localDataSource;

  @override
  Future<Either<Failure, Booking>> createBooking({
    required String movieTitle,
    required String showtimeId,
    required List<Seat> seats,
    required int totalPrice,
  }) async {
    try {
      final booking = await localDataSource.createBooking(
        movieTitle: movieTitle,
        showtimeId: showtimeId,
        seats: seats
            .map(
              (seat) => seat is SeatModel
                  ? seat
                  : SeatModel(
                      id: seat.id,
                      row: seat.row,
                      number: seat.number,
                      status: seat.status,
                    ),
            )
            .toList(growable: false),
        totalPrice: totalPrice,
      );

      return Right<Failure, Booking>(booking);
    } on CacheException catch (error) {
      return Left<Failure, Booking>(CacheFailure(error.message));
    } on ServerException catch (error) {
      return Left<Failure, Booking>(ServerFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, List<Seat>>> getSeats(String showtimeId) async {
    try {
      final seats = await localDataSource.getSeats(showtimeId);
      return Right<Failure, List<Seat>>(seats);
    } on CacheException catch (error) {
      return Left<Failure, List<Seat>>(CacheFailure(error.message));
    } on ServerException catch (error) {
      return Left<Failure, List<Seat>>(ServerFailure(error.message));
    }
  }
}
