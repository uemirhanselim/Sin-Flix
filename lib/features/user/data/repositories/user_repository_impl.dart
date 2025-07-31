import 'package:dartz/dartz.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  UserRepositoryImpl({required this.remoteDataSource, required this.sharedPreferences});

  @override
  Future<Either<Failure, UserEntity>> uploadPhoto({required File photo}) async {
    try {
      String fileName = photo.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(photo.path, filename: fileName),
      });
      final response = await remoteDataSource.uploadPhoto(formData);
      if (response.response.code == 200) {
        // Update local user data with new photoUrl if needed
        final userJson = jsonEncode(response.data.toJson());
        await sharedPreferences.setString('user', userJson);
        return Right(response.data);
      } else {
        return Left(ServerFailure(message: response.response.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
