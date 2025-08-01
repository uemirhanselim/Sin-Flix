import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class GetFavoriteMovies implements UseCase<List<MovieEntity>, NoParams> {
  final MovieRepository repository;

  GetFavoriteMovies(this.repository);

  @override
  Future<Either<Failure, List<MovieEntity>>> call(NoParams params) async {
    return await repository.getFavoriteMovies();
  }
}
