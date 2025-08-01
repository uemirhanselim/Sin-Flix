import 'package:json_annotation/json_annotation.dart';
import 'package:dating_app/features/auth/data/models/login_response_model.dart'; // ResponseModel için
import 'package:dating_app/features/auth/data/models/user_model.dart'; // UserModel için

part 'user_profile_response_model.g.dart';

@JsonSerializable()
class UserProfileResponseModel {
  final ResponseModel response;
  final UserModel data;

  UserProfileResponseModel({required this.response, required this.data});

  factory UserProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileResponseModelToJson(this);
}
