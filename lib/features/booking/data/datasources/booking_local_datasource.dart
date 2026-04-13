import 'dart:math';

import '../../../../core/error/exceptions.dart';
import '../models/booking_model.dart';
import '../models/seat_model.dart';
import '../../domain/entities/seat.dart';

abstract class BookingLocalDataSource {
  Future<List<SeatModel>> getSeats(String showtimeId);
  Future<BookingModel> createBooking({
    required String movieTitle,
    required String showtimeId,
    required List<SeatModel> seats,
    required int totalPrice,
  });
}

class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  BookingLocalDataSourceImpl() {
    _seedInitialLayouts();
  }

  final Random _random = Random();
  final Map<String, List<SeatModel>> _seatLayouts = <String, List<SeatModel>>{};
  final List<BookingModel> _bookings = <BookingModel>[];

  @override
  Future<BookingModel> createBooking({
    required String movieTitle,
    required String showtimeId,
    required List<SeatModel> seats,
    required int totalPrice,
  }) async {
    if (seats.isEmpty) {
      throw const CacheException('No seats selected for booking');
    }

    final currentLayout = _seatLayouts.putIfAbsent(
      showtimeId,
      () => _generateSeats(showtimeId),
    );

    final requestedSeatIds = seats.map((seat) => seat.id).toSet();
    final alreadyBooked = currentLayout.any(
      (seat) =>
          requestedSeatIds.contains(seat.id) && seat.status == SeatStatus.booked,
    );

    if (alreadyBooked) {
      throw const CacheException('One or more selected seats are already booked');
    }

    final updatedLayout = currentLayout.map((seat) {
      if (requestedSeatIds.contains(seat.id)) {
        return seat.copyWith(status: SeatStatus.booked);
      }

      return seat;
    }).toList(growable: false);

    _seatLayouts[showtimeId] = updatedLayout;

    final confirmedSeats = updatedLayout
        .where((seat) => requestedSeatIds.contains(seat.id))
        .toList(growable: false);

    final booking = BookingModel(
      id: 'bk_${DateTime.now().microsecondsSinceEpoch}',
      movieTitle: movieTitle,
      showtimeId: showtimeId,
      seats: confirmedSeats,
      totalPrice: totalPrice,
      status: 'confirmed',
    );

    _bookings.add(booking);
    return booking;
  }

  @override
  Future<List<SeatModel>> getSeats(String showtimeId) async {
    final seats = _seatLayouts.putIfAbsent(
      showtimeId,
      () => _generateSeats(showtimeId),
    );

    return seats
        .map(
          (seat) => seat.copyWith(),
        )
        .toList(growable: false);
  }

  void _seedInitialLayouts() {
    const showtimeIds = <String>[
      'st_1',
      'st_2',
      'st_3',
      'st_4',
      'st_5',
      'st_6',
      'st_7',
      'st_8',
      'st_9',
      'st_10',
      'st_11',
      'st_12',
    ];

    for (final showtimeId in showtimeIds) {
      _seatLayouts[showtimeId] = _generateSeats(showtimeId);
    }
  }

  List<SeatModel> _generateSeats(String showtimeId) {
    const rows = <String>['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
    const seatsPerRow = 8;
    const totalSeats = 64;
    final bookedTarget = (totalSeats * 0.3).round();
    final bookedIndexes = <int>{};

    while (bookedIndexes.length < bookedTarget) {
      bookedIndexes.add(_random.nextInt(totalSeats));
    }

    final generatedSeats = <SeatModel>[];
    var seatIndex = 0;

    for (final row in rows) {
      for (var number = 1; number <= seatsPerRow; number++) {
        final isBooked = bookedIndexes.contains(seatIndex);
        generatedSeats.add(
          SeatModel(
            id: '$showtimeId-$row$number',
            row: row,
            number: number,
            status: isBooked ? SeatStatus.booked : SeatStatus.available,
          ),
        );
        seatIndex++;
      }
    }

    return generatedSeats;
  }
}
