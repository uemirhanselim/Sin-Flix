import 'package:json_annotation/json_annotation.dart';
import 'package:dating_app/features/auth/data/models/login_response_model.dart'; // ResponseModel için
import 'movie_model.dart';

part 'favorite_movies_response_model.g.dart';

@JsonSerializable()
class FavoriteMoviesResponseModel {
  final ResponseModel response;
  final List<MovieModel> data;

  FavoriteMoviesResponseModel({required this.response, required this.data});

  factory FavoriteMoviesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteMoviesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteMoviesResponseModelToJson(this);
}
