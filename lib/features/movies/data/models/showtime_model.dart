import '../../domain/entities/showtime.dart';

class ShowtimeModel extends Showtime {
  const ShowtimeModel({
    required super.id,
    required super.movieId,
    required super.date,
    required super.time,
    required super.cinemaName,
    required super.price,
    required super.availableSeats,
  });

  factory ShowtimeModel.fromJson(Map<String, dynamic> json) {
    return ShowtimeModel(
      id: json['id'] as String,
      movieId: json['movieId'] as String,
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String,
      cinemaName: json['cinemaName'] as String,
      price: json['price'] as int,
      availableSeats: json['availableSeats'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'movieId': movieId,
      'date': date.toIso8601String(),
      'time': time,
      'cinemaName': cinemaName,
      'price': price,
      'availableSeats': availableSeats,
    };
  }
}
