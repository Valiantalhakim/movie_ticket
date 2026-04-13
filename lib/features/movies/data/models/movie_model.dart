import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.genre,
    required super.rating,
    required super.poster,
    required super.synopsis,
    required super.duration,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as String,
      title: json['title'] as String,
      genre: json['genre'] as String,
      rating: (json['rating'] as num).toDouble(),
      poster: json['poster'] as String,
      synopsis: json['synopsis'] as String,
      duration: json['duration'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'genre': genre,
      'rating': rating,
      'poster': poster,
      'synopsis': synopsis,
      'duration': duration,
    };
  }
}
