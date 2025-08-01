import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? token;
  final String? photoUrl;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.token,
    this.photoUrl,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
    String? photoUrl,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [id, email, name, token, photoUrl];
} 