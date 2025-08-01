import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/movie_repository.dart';

class ToggleFavorite implements UseCase<void, ToggleFavoriteParams> {
  final MovieRepository repository;

  ToggleFavorite(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleFavoriteParams params) async {
    return await repository.toggleFavorite(favoriteId: params.movieId, isFavorite: params.isFavorite);
  }
}

class ToggleFavoriteParams {
  final String movieId;
  final bool isFavorite;

  ToggleFavoriteParams({required this.movieId, required this.isFavorite});
}
