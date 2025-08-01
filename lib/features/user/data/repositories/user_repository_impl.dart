import 'package:dartz/dartz.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../core/errors/failures.dart';
import '../../../auth/data/models/user_model.dart';
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
        // Update local user data with new photoUrl
        final userJsonString = sharedPreferences.getString('user');
        if (userJsonString != null) {
          final userMap = jsonDecode(userJsonString) as Map<String, dynamic>;
          final currentUserModel = UserModel.fromJson(userMap);
          final updatedUserModel = currentUserModel.copyWith(photoUrl: response.data.photoUrl); // Assuming response.data has photoUrl
          await sharedPreferences.setString('user', jsonEncode(updatedUserModel.toJson()));
        }
        return Right(response.data);
      } else {
        return Left(ServerFailure(message: response.response.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      final response = await remoteDataSource.getUserProfile();
      if (response.response.code == 200) {
        return Right(response.data);
      } else {
        return Left(ServerFailure(message: response.response.message));
      }
    } on DioException catch (e) {
      String errorMessage = 'Bilinmeyen bir ağ hatası oluştu.';
      if (e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response!.data['message'] ?? errorMessage;
      }
      return Left(ServerFailure(message: errorMessage));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
