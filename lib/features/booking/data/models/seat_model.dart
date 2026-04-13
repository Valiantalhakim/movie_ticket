import '../../domain/entities/seat.dart';

class SeatModel extends Seat {
  const SeatModel({
    required super.id,
    required super.row,
    required super.number,
    required super.status,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      id: json['id'] as String,
      row: json['row'] as String,
      number: json['number'] as int,
      status: SeatStatus.values.firstWhere(
        (value) => value.name == json['status'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'row': row,
      'number': number,
      'status': status.name,
    };
  }

  SeatModel copyWith({
    String? id,
    String? row,
    int? number,
    SeatStatus? status,
  }) {
    return SeatModel(
      id: id ?? this.id,
      row: row ?? this.row,
      number: number ?? this.number,
      status: status ?? this.status,
    );
  }
}
