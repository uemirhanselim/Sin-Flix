import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MovieEntity>>> getMovieList({required int page}) async {
    try {
      final response = await remoteDataSource.getMovieList(page: page);
      if (response.response.code != 200) {
        return Left(ServerFailure(message: response.response.message ?? 'Sunucudan hata mesajı alınamadı. Kod: ${response.response.code}'));
      }
      return Right(response.data.movies.map((model) => model.toEntity()).toList());
    } on DioException catch (e) {
      String errorMessage = 'Bilinmeyen bir ağ hatası oluştu.';
      if (e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response!.data['message'] ?? errorMessage;
      }
      return Left(ServerFailure(message: errorMessage));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite({required String favoriteId, required bool isFavorite}) async {
    try {
      await remoteDataSource.toggleFavorite(favoriteId: favoriteId, isFavorite: isFavorite);
      return const Right(null);
    } on DioException catch (e) {
      String errorMessage = 'Bilinmeyen bir ağ hatası oluştu.';
      if (e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response!.data['message'] ?? errorMessage;
      }
      return Left(ServerFailure(message: errorMessage));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getFavoriteMovies() async {
    try {
      final response = await remoteDataSource.getFavoriteMovies();
      if (response.response.code != 200) {
        return Left(ServerFailure(message: response.response.message ?? 'Sunucudan hata mesajı alınamadı. Kod: ${response.response.code}'));
      }
      return Right(response.data.map((model) => model.toEntity()).toList());
    } on DioException catch (e) {
      String errorMessage = 'Bilinmeyen bir ağ hatası oluştu.';
      if (e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response!.data['message'] ?? errorMessage;
      }
      return Left(ServerFailure(message: errorMessage));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
