enum SeatStatus {
  available,
  selected,
  booked,
}

class Seat {
  const Seat({
    required this.id,
    required this.row,
    required this.number,
    required this.status,
  });

  final String id;
  final String row;
  final int number;
  final SeatStatus status;
}
