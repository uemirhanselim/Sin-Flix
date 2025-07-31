// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponseModel _$LoginResponseModelFromJson(Map<String, dynamic> json) =>
    LoginResponseModel(
      response:
          ResponseModel.fromJson(json['response'] as Map<String, dynamic>),
      data: UserModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseModelToJson(LoginResponseModel instance) =>
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
