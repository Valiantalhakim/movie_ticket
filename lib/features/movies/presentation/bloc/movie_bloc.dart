import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/showtime.dart';
import '../../domain/usecases/get_movie_detail.dart';
import '../../domain/usecases/get_now_playing.dart';
import '../../domain/usecases/get_showtimes.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc({
    required GetNowPlaying getNowPlaying,
    required GetMovieDetail getMovieDetail,
    required GetShowtimes getShowtimes,
  })  : _getNowPlaying = getNowPlaying,
        _getMovieDetail = getMovieDetail,
        _getShowtimes = getShowtimes,
        super(const MovieInitial()) {
    on<LoadMoviesEvent>(_onLoadMovies);
    on<LoadMovieDetailEvent>(_onLoadMovieDetail);
    on<LoadShowtimesEvent>(_onLoadShowtimes);
  }

  final GetNowPlaying _getNowPlaying;
  final GetMovieDetail _getMovieDetail;
  final GetShowtimes _getShowtimes;

  Future<void> _onLoadMovies(
    LoadMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    final previous = state;
    emit(
      MovieLoading(
        movies: previous is MovieLoaded ? previous.movies : const <Movie>[],
        selectedMovie:
            previous is MovieLoaded ? previous.selectedMovie : null,
        showtimes:
            previous is MovieLoaded ? previous.showtimes : const <Showtime>[],
      ),
    );

    final result = await _getNowPlaying();
    result.fold(
      (failure) => emit(MovieError(_mapFailureToMessage(failure))),
      (movies) => emit(MovieLoaded(movies: movies)),
    );
  }

  Future<void> _onLoadMovieDetail(
    LoadMovieDetailEvent event,
    Emitter<MovieState> emit,
  ) async {
    final previousMovies =
        state is MovieLoaded ? (state as MovieLoaded).movies : const <Movie>[];
    final previousShowtimes = state is MovieLoaded
        ? (state as MovieLoaded).showtimes
        : const <Showtime>[];

    emit(
      MovieLoading(
        movies: previousMovies,
        selectedMovie:
            state is MovieLoaded ? (state as MovieLoaded).selectedMovie : null,
        showtimes: previousShowtimes,
      ),
    );

    final detailResult = await _getMovieDetail(event.movieId);
    detailResult.fold(
      (failure) => emit(MovieError(_mapFailureToMessage(failure))),
      (movie) => emit(
        MovieLoaded(
          movies: previousMovies,
          selectedMovie: movie,
          showtimes: previousShowtimes,
        ),
      ),
    );
  }

  Future<void> _onLoadShowtimes(
    LoadShowtimesEvent event,
    Emitter<MovieState> emit,
  ) async {
    final previousMovies =
        state is MovieLoaded ? (state as MovieLoaded).movies : const <Movie>[];
    final previousSelectedMovie =
        state is MovieLoaded ? (state as MovieLoaded).selectedMovie : null;

    emit(
      MovieLoading(
        movies: previousMovies,
        selectedMovie: previousSelectedMovie,
        showtimes: state is MovieLoaded
            ? (state as MovieLoaded).showtimes
            : const <Showtime>[],
      ),
    );

    final showtimeResult = await _getShowtimes(event.movieId);
    showtimeResult.fold(
      (failure) => emit(MovieError(_mapFailureToMessage(failure))),
      (showtimes) => emit(
        MovieLoaded(
          movies: previousMovies,
          selectedMovie: previousSelectedMovie,
          showtimes: showtimes,
        ),
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
