import 'package:json_annotation/json_annotation.dart';

part 'register_response_model.g.dart';

@JsonSerializable()
class RegisterResponseModel {
  final ResponseModel response;
  final dynamic data;

  RegisterResponseModel({required this.response, this.data});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) => _$RegisterResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterResponseModelToJson(this);
}

@JsonSerializable()
class ResponseModel {
  final int code;
  final String message;

  ResponseModel({required this.code, required this.message});

  factory ResponseModel.fromJson(Map<String, dynamic> json) => _$ResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}
