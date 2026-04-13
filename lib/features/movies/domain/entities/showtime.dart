class Showtime {
  const Showtime({
    required this.id,
    required this.movieId,
    required this.date,
    required this.time,
    required this.cinemaName,
    required this.price,
    required this.availableSeats,
  });

  final String id;
  final String movieId;
  final DateTime date;
  final String time;
  final String cinemaName;
  final int price;
  final int availableSeats;
}
