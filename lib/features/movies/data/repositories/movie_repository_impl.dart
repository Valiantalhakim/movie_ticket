import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/showtime.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_local_datasource.dart';

class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
  });

  final MovieLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, Movie>> getMovieDetail(String id) async {
    try {
      final movie = await localDataSource.getMovieDetail(id);
      return Right<Failure, Movie>(movie);
    } on CacheException catch (error) {
      return Left<Failure, Movie>(CacheFailure(error.message));
    } on ServerException catch (error) {
      return Left<Failure, Movie>(ServerFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getNowPlaying() async {
    try {
      await networkInfo.isConnected;
      final movies = await localDataSource.getNowPlaying();
      return Right<Failure, List<Movie>>(movies);
    } on CacheException catch (error) {
      return Left<Failure, List<Movie>>(CacheFailure(error.message));
    } on ServerException catch (error) {
      return Left<Failure, List<Movie>>(ServerFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, List<Showtime>>> getShowtimes(String movieId) async {
    try {
      final showtimes = await localDataSource.getShowtimes(movieId);
      return Right<Failure, List<Showtime>>(showtimes);
    } on CacheException catch (error) {
      return Left<Failure, List<Showtime>>(CacheFailure(error.message));
    } on ServerException catch (error) {
      return Left<Failure, List<Showtime>>(ServerFailure(error.message));
    }
  }
}
