import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/movie.dart';
import '../entities/showtime.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getNowPlaying();
  Future<Either<Failure, Movie>> getMovieDetail(String id);
  Future<Either<Failure, List<Showtime>>> getShowtimes(String movieId);
}
