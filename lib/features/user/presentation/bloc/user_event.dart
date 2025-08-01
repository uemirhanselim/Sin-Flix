import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class UploadUserPhotoEvent extends UserEvent {
  final File photo;

  const UploadUserPhotoEvent({required this.photo});

  @override
  List<Object> get props => [photo];
}

class LoadUserProfile extends UserEvent {}
