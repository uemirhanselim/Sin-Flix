import 'package:equatable/equatable.dart';
import 'dart:io';

enum ProfileDetailStatus { initial, loading, success, failure }

class ProfileDetailState extends Equatable {
  final File? profileImage;
  final ProfileDetailStatus status;

  const ProfileDetailState({
    this.profileImage,
    this.status = ProfileDetailStatus.initial,
  });

  ProfileDetailState copyWith({
    File? profileImage,
    ProfileDetailStatus? status,
  }) {
    return ProfileDetailState(
      profileImage: profileImage ?? this.profileImage,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [profileImage, status];
}

class ProfileDetailUploadRequested extends ProfileDetailState {
  const ProfileDetailUploadRequested({File? profileImage, ProfileDetailStatus status = ProfileDetailStatus.initial}) : super(profileImage: profileImage, status: status);

  @override
  List<Object?> get props => [profileImage, status];
}
