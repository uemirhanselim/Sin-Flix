import 'package:dating_app/core/usecases/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/logger_service.dart';
import '../../domain/usecases/upload_user_photo.dart';
import '../../domain/usecases/get_user_profile.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UploadUserPhoto uploadUserPhoto;
  final GetUserProfile getUserProfile;
  final LoggerService logger;

  UserBloc({
    required this.uploadUserPhoto,
    required this.getUserProfile,
    required this.logger,
  }) : super(UserInitial()) {
    on<UploadUserPhotoEvent>(_onUploadUserPhotoEvent);
    on<LoadUserProfile>(_onLoadUserProfile);
  }

  Future<void> _onUploadUserPhotoEvent(
    UploadUserPhotoEvent event,
    Emitter<UserState> emit,
  ) async {
    print("devamkeeeee");
    emit(UserLoading());
    final result = await uploadUserPhoto(
      UploadUserPhotoParams(photo: event.photo),
    );

    result.fold(
      (failure) {
        logger.e('Photo upload failed', failure.message);
        emit(UserError(message: failure.message));
      },
      (user) {
        logger.i('Photo uploaded successfully');
        emit(UserPhotoUploaded(user: user));
      },
    );
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await getUserProfile(NoParams());

    result.fold(
      (failure) {
        logger.e('Failed to load user profile', failure.message);
        emit(UserError(message: failure.message));
      },
      (user) {
        logger.i('User profile loaded successfully');
        emit(UserProfileLoaded(user: user));
      },
    );
  }
}
