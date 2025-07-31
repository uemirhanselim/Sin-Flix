import '../../domain/entities/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  const UserModel({
    required String id,
    required String email,
    String? name,
    String? token,
  }) : super(id: id, email: email, name: name, token: token);

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
} 