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
    String? photoUrl,
  }) : super(id: id, email: email, name: name, token: token, photoUrl: photoUrl);

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
    String? photoUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
 