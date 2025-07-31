import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class ProfileDetailEvent extends Equatable {
  const ProfileDetailEvent();

  @override
  List<Object?> get props => [];
}

class ProfileImagePicked extends ProfileDetailEvent {
  final File image;

  const ProfileImagePicked(this.image);

  @override
  List<Object?> get props => [image];
}

class ContinuePressed extends ProfileDetailEvent {}
