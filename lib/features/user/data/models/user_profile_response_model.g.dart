// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileResponseModel _$UserProfileResponseModelFromJson(
        Map<String, dynamic> json) =>
    UserProfileResponseModel(
      response:
          ResponseModel.fromJson(json['response'] as Map<String, dynamic>),
      data: UserModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserProfileResponseModelToJson(
        UserProfileResponseModel instance) =>
    <String, dynamic>{
      'response': instance.response,
      'data': instance.data,
    };
