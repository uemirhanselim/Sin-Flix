// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_movies_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteMoviesResponseModel _$FavoriteMoviesResponseModelFromJson(
        Map<String, dynamic> json) =>
    FavoriteMoviesResponseModel(
      response:
          ResponseModel.fromJson(json['response'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>)
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FavoriteMoviesResponseModelToJson(
        FavoriteMoviesResponseModel instance) =>
    <String, dynamic>{
      'response': instance.response,
      'data': instance.data,
    };
