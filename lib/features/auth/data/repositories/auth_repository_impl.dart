import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.register(
        RegisterRequestModel(name: name, email: email, password: password),
      );
      return Right(UserEntity(id: '', name: name, email: email));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.login(
        LoginRequestModel(email: email, password: password),
      );
      if (response.response.code == 200) {
        await secureStorage.write(key: 'token', value: response.data.token);
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
