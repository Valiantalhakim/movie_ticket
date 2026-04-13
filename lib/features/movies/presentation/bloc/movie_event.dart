part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoadMoviesEvent extends MovieEvent {
  const LoadMoviesEvent();
}

class LoadMovieDetailEvent extends MovieEvent {
  const LoadMovieDetailEvent(this.movieId);

  final String movieId;

  @override
  List<Object?> get props => <Object?>[movieId];
}

class LoadShowtimesEvent extends MovieEvent {
  const LoadShowtimesEvent(this.movieId);

  final String movieId;

  @override
  List<Object?> get props => <Object?>[movieId];
}
