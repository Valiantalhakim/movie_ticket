import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/showtime.dart';
import '../repositories/movie_repository.dart';

class GetShowtimes {
  const GetShowtimes(this.repository);

  final MovieRepository repository;

  Future<Either<Failure, List<Showtime>>> call(String movieId) {
    return repository.getShowtimes(movieId);
  }
}
