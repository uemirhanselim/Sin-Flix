import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/movie_entity.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<MovieEntity>>> getMovieList({required int page});
  Future<Either<Failure, void>> toggleFavorite({required String favoriteId, required bool isFavorite});
  Future<Either<Failure, List<MovieEntity>>> getFavoriteMovies();
}
