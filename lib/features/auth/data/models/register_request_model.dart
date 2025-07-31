import 'package:json_annotation/json_annotation.dart';

part 'register_request_model.g.dart';

@JsonSerializable()
class RegisterRequestModel {
  final String email;
  final String name;
  final String password;

  RegisterRequestModel({required this.email, required this.name, required this.password});

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) => _$RegisterRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}
