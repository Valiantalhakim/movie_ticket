part of 'movie_bloc.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object?> get props => <Object?>[];
}

class MovieInitial extends MovieState {
  const MovieInitial();
}

class MovieLoading extends MovieState {
  const MovieLoading({
    this.movies = const <Movie>[],
    this.selectedMovie,
    this.showtimes = const <Showtime>[],
  });

  final List<Movie> movies;
  final Movie? selectedMovie;
  final List<Showtime> showtimes;

  @override
  List<Object?> get props => <Object?>[movies, selectedMovie, showtimes];
}

class MovieLoaded extends MovieState {
  const MovieLoaded({
    this.movies = const <Movie>[],
    this.selectedMovie,
    this.showtimes = const <Showtime>[],
  });

  final List<Movie> movies;
  final Movie? selectedMovie;
  final List<Showtime> showtimes;

  @override
  List<Object?> get props => <Object?>[movies, selectedMovie, showtimes];
}

class MovieError extends MovieState {
  const MovieError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
