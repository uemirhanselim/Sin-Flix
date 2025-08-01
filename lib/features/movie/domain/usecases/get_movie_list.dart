import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class GetMovieList implements UseCase<List<MovieEntity>, GetMovieListParams> {
  final MovieRepository repository;

  GetMovieList(this.repository);

  @override
  Future<Either<Failure, List<MovieEntity>>> call(GetMovieListParams params) async {
    return await repository.getMovieList(page: params.page);
  }
}

class GetMovieListParams {
  final int page;

  GetMovieListParams({required this.page});
}
