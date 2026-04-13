import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetail {
  const GetMovieDetail(this.repository);

  final MovieRepository repository;

  Future<Either<Failure, Movie>> call(String id) {
    return repository.getMovieDetail(id);
  }
}
