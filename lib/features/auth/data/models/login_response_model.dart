import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  final ResponseModel response;
  final UserModel data;

  LoginResponseModel({required this.response, required this.data});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}

@JsonSerializable()
class ResponseModel {
  final int code;
  final String message;

  ResponseModel({required this.code, required this.message});

  factory ResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}
