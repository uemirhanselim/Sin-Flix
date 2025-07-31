import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import '../../../user/domain/usecases/upload_user_photo.dart';
import 'profile_detail_event.dart';
import 'profile_detail_state.dart';

class ProfileDetailBloc extends Bloc<ProfileDetailEvent, ProfileDetailState> {
  final UploadUserPhoto uploadUserPhoto;

  ProfileDetailBloc({required this.uploadUserPhoto}) : super(const ProfileDetailState()) {
    on<ProfileImagePicked>(_onProfileImagePicked);
    on<ContinuePressed>(_onContinuePressed);
  }

  void _onProfileImagePicked(ProfileImagePicked event, Emitter<ProfileDetailState> emit) {
    emit(state.copyWith(profileImage: event.image));
  }

  void _onContinuePressed(ContinuePressed event, Emitter<ProfileDetailState> emit) {
    if (state.profileImage != null) {
      emit(ProfileDetailUploadRequested(profileImage: state.profileImage, status: ProfileDetailStatus.loading));
    }
    // TODO: Implement other continue logic if needed
  }
}
