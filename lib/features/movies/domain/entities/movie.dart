class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.rating,
    required this.poster,
    required this.synopsis,
    required this.duration,
  });

  final String id;
  final String title;
  final String genre;
  final double rating;
  final String poster;
  final String synopsis;
  final int duration;
}
