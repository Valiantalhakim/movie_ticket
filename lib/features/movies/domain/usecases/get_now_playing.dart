import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetNowPlaying {
  const GetNowPlaying(this.repository);

  final MovieRepository repository;

  Future<Either<Failure, List<Movie>>> call() {
    return repository.getNowPlaying();
  }
}
