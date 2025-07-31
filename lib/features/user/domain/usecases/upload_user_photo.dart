import 'package:dartz/dartz.dart';
import 'dart:io';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';
import '../../../auth/domain/entities/user_entity.dart';

class UploadUserPhoto implements UseCase<UserEntity, UploadUserPhotoParams> {
  final UserRepository repository;

  UploadUserPhoto(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UploadUserPhotoParams params) async {
    return await repository.uploadPhoto(photo: params.photo);
  }
}

class UploadUserPhotoParams {
  final File photo;

  UploadUserPhotoParams({required this.photo});
}
