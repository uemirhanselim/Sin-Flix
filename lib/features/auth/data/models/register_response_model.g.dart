// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterResponseModel _$RegisterResponseModelFromJson(
        Map<String, dynamic> json) =>
    RegisterResponseModel(
      response:
          ResponseModel.fromJson(json['response'] as Map<String, dynamic>),
      data: json['data'],
    );

Map<String, dynamic> _$RegisterResponseModelToJson(
        RegisterResponseModel instance) =>
    <String, dynamic>{
      'response': instance.response,
      'data': instance.data,
    };

ResponseModel _$ResponseModelFromJson(Map<String, dynamic> json) =>
    ResponseModel(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$ResponseModelToJson(ResponseModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
