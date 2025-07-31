import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/logger_service.dart';
import '../../domain/usecases/upload_user_photo.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UploadUserPhoto uploadUserPhoto;
  final LoggerService logger;

  UserBloc({
    required this.uploadUserPhoto,
    required this.logger,
  }) : super(UserInitial()) {
    on<UploadUserPhotoEvent>(_onUploadUserPhotoEvent);
  }

  Future<void> _onUploadUserPhotoEvent(UploadUserPhotoEvent event, Emitter<UserState> emit) async {
    print("devamkeeeee");
    emit(UserLoading());
    final result = await uploadUserPhoto(UploadUserPhotoParams(photo: event.photo));

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
}
