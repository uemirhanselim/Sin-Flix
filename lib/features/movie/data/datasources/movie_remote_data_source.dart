import 'dart:convert';
import 'package:dating_app/core/services/logger_service.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/movie_list_response_model.dart';

part 'movie_remote_data_source.g.dart';

@RestApi(baseUrl: "https://caseapi.servicelabs.tech/")
abstract class MovieApiService {
  factory MovieApiService(Dio dio, {String baseUrl}) = _MovieApiService;

  @GET("movie/list")
  Future<MovieListResponseModel> getMovieList(@Query("page") int page);
}

abstract class MovieRemoteDataSource {
  Future<MovieListResponseModel> getMovieList({required int page});
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final MovieApiService _apiService;
  final LoggerService _logger;

  MovieRemoteDataSourceImpl(this._apiService, this._logger);

  @override
  Future<MovieListResponseModel> getMovieList({required int page}) async {
    try {
      _logger.i('Fetching movie list for page: $page');
      final response = await _apiService.getMovieList(page);

      // Log the full JSON response
      final responseJson = jsonEncode(response.toJson());
      _logger.d('Full API Response: $responseJson');

      _logger.i('Movie list response code: ${response.response.code}');
      _logger.i('Movie list response message: ${response.response.message}');
      return response;
    } on DioException catch (e) {
      String errorMessage = 'Bilinmeyen bir ağ hatası oluştu.';
      if (e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response!.data['message'] ?? errorMessage;
      }
      _logger.e('Dio Error fetching movie list', errorMessage, e.stackTrace);
      rethrow;
    } catch (e) {
      _logger.e('Error fetching movie list', e.toString());
      rethrow;
    }
  }
}
