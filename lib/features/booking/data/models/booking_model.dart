import '../../domain/entities/booking.dart';
import 'seat_model.dart';

class BookingModel extends Booking {
  BookingModel({
    required super.id,
    required super.movieTitle,
    required super.showtimeId,
    required super.seats,
    required super.totalPrice,
    required super.status,
    super.cinemaName,
    super.showDate,
    super.showTime,
    super.paymentMethod,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      movieTitle: json['movieTitle'] as String,
      showtimeId: json['showtimeId'] as String,
      seats: (json['seats'] as List<dynamic>)
          .map(
            (seat) => SeatModel.fromJson(seat as Map<String, dynamic>),
          )
          .toList(growable: false),
      totalPrice: json['totalPrice'] as int,
      status: json['status'] as String,
      cinemaName: json['cinemaName'] as String?,
      showDate: json['showDate'] == null
          ? null
          : DateTime.parse(json['showDate'] as String),
      showTime: json['showTime'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'movieTitle': movieTitle,
      'showtimeId': showtimeId,
      'seats': seats
          .map((seat) {
            if (seat is SeatModel) {
              return seat.toJson();
            }

            return SeatModel(
              id: seat.id,
              row: seat.row,
              number: seat.number,
              status: seat.status,
            ).toJson();
          })
          .toList(growable: false),
      'totalPrice': totalPrice,
      'status': status,
      'cinemaName': cinemaName,
      'showDate': showDate?.toIso8601String(),
      'showTime': showTime,
      'paymentMethod': paymentMethod,
    };
  }

  List<SeatModel> get seatModels {
    return seats
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
        .toList(growable: false);
  }
}
