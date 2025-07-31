import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'upload_photo_response_model.g.dart';

@JsonSerializable()
class UploadPhotoResponseModel {
  final ResponseModel response;
  final UserModel data;

  UploadPhotoResponseModel({required this.response, required this.data});

  factory UploadPhotoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UploadPhotoResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadPhotoResponseModelToJson(this);
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
