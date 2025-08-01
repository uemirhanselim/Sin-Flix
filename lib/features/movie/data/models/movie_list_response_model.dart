import 'package:json_annotation/json_annotation.dart';
import 'movie_model.dart';
import 'pagination_model.dart';
import 'response_model.dart';

part 'movie_list_response_model.g.dart';

@JsonSerializable()
class MovieListResponseModel {
  final ResponseModel response;
  final MovieListDataModel data;

  MovieListResponseModel({required this.response, required this.data});

  factory MovieListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MovieListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieListResponseModelToJson(this);
}

@JsonSerializable()
class MovieListDataModel {
  final List<MovieModel> movies;
  final PaginationModel pagination;

  MovieListDataModel({required this.movies, required this.pagination});

  factory MovieListDataModel.fromJson(Map<String, dynamic> json) =>
      _$MovieListDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieListDataModelToJson(this);
}
